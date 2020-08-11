Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514362416BB
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 08:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgHKG7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 02:59:53 -0400
Received: from ja.ssi.bg ([178.16.129.10]:33602 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728170AbgHKG7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 02:59:53 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 07B6wk1t005940;
        Tue, 11 Aug 2020 09:58:46 +0300
Date:   Tue, 11 Aug 2020 09:58:46 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Peilin Ye <yepeilin.cs@gmail.com>
cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-kernel-mentees] [PATCH net] ipvs: Fix uninit-value in
 do_ip_vs_set_ctl()
In-Reply-To: <20200811050929.GA821443@PWN>
Message-ID: <alpine.LFD.2.23.451.2008110936570.3707@ja.home.ssi.bg>
References: <20200810220703.796718-1-yepeilin.cs@gmail.com> <CAM_iQpWsQubVJ-AYaLHujHwz68+nsHBcbgbf8XPMEPD=Vu+zaA@mail.gmail.com> <20200811050929.GA821443@PWN>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Tue, 11 Aug 2020, Peilin Ye wrote:

> On Mon, Aug 10, 2020 at 08:57:19PM -0700, Cong Wang wrote:
> > On Mon, Aug 10, 2020 at 3:10 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> > >
> > > do_ip_vs_set_ctl() is referencing uninitialized stack value when `len` is
> > > zero. Fix it.
> > 
> > Which exact 'cmd' is it here?
> > 
> > I _guess_ it is one of those uninitialized in set_arglen[], which is 0.
> 
> Yes, it was `IP_VS_SO_SET_NONE`, implicitly initialized to zero.
> 
> > But if that is the case, should it be initialized to
> > sizeof(struct ip_vs_service_user) instead because ip_vs_copy_usvc_compat()
> > is called anyway. Or, maybe we should just ban len==0 case.
> 
> I see. I think the latter would be easier, but we cannot ban all of
> them, since the function does something with `IP_VS_SO_SET_FLUSH`, which
> is a `len == 0` case.
> 
> Maybe we do something like this?

	Yes, only IP_VS_SO_SET_FLUSH uses len 0. We can go with
this change but you do not need to target net tree, as the
problem is not fatal net-next works too. What happens is
that we may lookup services with random search keys which
is harmless.

	Another option is to add new block after this one:

        } else if (cmd == IP_VS_SO_SET_TIMEOUT) {
                /* Set timeout values for (tcp tcpfin udp) */
                ret = ip_vs_set_timeout(ipvs, (struct ip_vs_timeout_user *)arg);
                goto out_unlock;
        }

	such as:

	} else if (!len) {
		/* No more commands with len=0 below */
		ret = -EINVAL;
		goto out_unlock;
	}

	It give more chance for future commands to use len=0
but the drawback is that the check happens under mutex. So, I'm
fine with both versions, it is up to you to decide :)

> @@ -2432,6 +2432,8 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
> 
>  	if (cmd < IP_VS_BASE_CTL || cmd > IP_VS_SO_SET_MAX)
>  		return -EINVAL;
> +	if (len == 0 && cmd != IP_VS_SO_SET_FLUSH)
> +		return -EINVAL;
>  	if (len != set_arglen[CMDID(cmd)]) {
>  		IP_VS_DBG(1, "set_ctl: len %u != %u\n",
>  			  len, set_arglen[CMDID(cmd)]);
> @@ -2547,9 +2549,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
>  		break;
>  	case IP_VS_SO_SET_DELDEST:
>  		ret = ip_vs_del_dest(svc, &udest);
> -		break;
> -	default:
> -		ret = -EINVAL;
>  	}
> 
>    out_unlock:

Regards

--
Julian Anastasov <ja@ssi.bg>
