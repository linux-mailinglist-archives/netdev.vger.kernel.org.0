Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4388624A1DC
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgHSOhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbgHSOhT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 10:37:19 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AACFE20738;
        Wed, 19 Aug 2020 14:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597847838;
        bh=9XcrtgpDa8lRtRYF9tZCoWHfFG44dFLLY6OtC69LqnQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OowIhNuEd45rf/oFvYaOaETAGF+uvia8dB0Otcx6KfXxpYoM5JxASnYfjSb2YQfgj
         5Ze4YoRi6VKMI3ZznYjQmc6sLIEd+20Ek70ZpcUQ4IMFkQTGStuQ3EPqkY3420WEdC
         38xm9QiDDEVR790ymYcElxSonP2HDMCEbqyHXw6k=
Received: by pali.im (Postfix)
        id D79AD582; Wed, 19 Aug 2020 16:37:16 +0200 (CEST)
Date:   Wed, 19 Aug 2020 16:37:16 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Joseph Hwang <josephsih@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Joseph Hwang <josephsih@google.com>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 2/2] Bluetooth: sco: expose WBS packet length in
 socket option
Message-ID: <20200819143716.iimo4l3uul7lrpjn@pali>
References: <20200813084129.332730-1-josephsih@chromium.org>
 <20200813164059.v1.2.I03247d3813c6dcbcdbeab26d068f9fd765edb1f5@changeid>
 <CABBYNZJ-nBXeujF2WkMEPYPQhXAphqKCV39gr-QYFdTC3GvjXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABBYNZJ-nBXeujF2WkMEPYPQhXAphqKCV39gr-QYFdTC3GvjXg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 14 August 2020 12:56:05 Luiz Augusto von Dentz wrote:
> Hi Joseph,
> 
> On Thu, Aug 13, 2020 at 1:42 AM Joseph Hwang <josephsih@chromium.org> wrote:
> >
> > It is desirable to expose the wideband speech packet length via
> > a socket option to the user space so that the user space can set
> > the value correctly in configuring the sco connection.
> >
> > Reviewed-by: Alain Michaud <alainm@chromium.org>
> > Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> > ---
> >
> >  include/net/bluetooth/bluetooth.h | 2 ++
> >  net/bluetooth/sco.c               | 8 ++++++++
> >  2 files changed, 10 insertions(+)
> >
> > diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
> > index 9125effbf4483d..922cc03143def4 100644
> > --- a/include/net/bluetooth/bluetooth.h
> > +++ b/include/net/bluetooth/bluetooth.h
> > @@ -153,6 +153,8 @@ struct bt_voice {
> >
> >  #define BT_SCM_PKT_STATUS      0x03
> >
> > +#define BT_SCO_PKT_LEN         17
> > +
> >  __printf(1, 2)
> >  void bt_info(const char *fmt, ...);
> >  __printf(1, 2)
> > diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> > index dcf7f96ff417e6..97e4e7c7b8cf62 100644
> > --- a/net/bluetooth/sco.c
> > +++ b/net/bluetooth/sco.c
> > @@ -67,6 +67,7 @@ struct sco_pinfo {
> >         __u32           flags;
> >         __u16           setting;
> >         __u8            cmsg_mask;
> > +       __u32           pkt_len;
> >         struct sco_conn *conn;
> >  };
> >
> > @@ -267,6 +268,8 @@ static int sco_connect(struct sock *sk)
> >                 sco_sock_set_timer(sk, sk->sk_sndtimeo);
> >         }
> >
> > +       sco_pi(sk)->pkt_len = hdev->sco_pkt_len;
> > +
> >  done:
> >         hci_dev_unlock(hdev);
> >         hci_dev_put(hdev);
> > @@ -1001,6 +1004,11 @@ static int sco_sock_getsockopt(struct socket *sock, int level, int optname,
> >                         err = -EFAULT;
> >                 break;
> >
> > +       case BT_SCO_PKT_LEN:
> > +               if (put_user(sco_pi(sk)->pkt_len, (u32 __user *)optval))
> > +                       err = -EFAULT;
> > +               break;
> 
> Couldn't we expose this via BT_SNDMTU/BT_RCVMTU?

Hello!

There is already SCO_OPTIONS sock option, uses struct sco_options and
contains 'mtu' member.

I think that instead of adding new sock option, existing SCO_OPTIONS
option should be used.

> >         default:
> >                 err = -ENOPROTOOPT;
> >                 break;
> > --
> > 2.28.0.236.gb10cc79966-goog
> >
> 
> 
> -- 
> Luiz Augusto von Dentz
