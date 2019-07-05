Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BD0600C1
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 08:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfGEGCD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Jul 2019 02:02:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:44326 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbfGEGCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 02:02:03 -0400
Received: from ALA-HCA.corp.ad.wrs.com ([147.11.189.40])
        by mail.windriver.com (8.15.2/8.15.1) with ESMTPS id x65620xC012341
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Thu, 4 Jul 2019 23:02:00 -0700 (PDT)
Received: from ALA-MBD.corp.ad.wrs.com ([169.254.3.194]) by
 ALA-HCA.corp.ad.wrs.com ([147.11.189.40]) with mapi id 14.03.0439.000; Thu, 4
 Jul 2019 23:02:00 -0700
From:   "Hallsmark, Per" <Per.Hallsmark@windriver.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] let proc net directory inodes reflect to active net
 namespace
Thread-Topic: [PATCH v2] let proc net directory inodes reflect to active net
 namespace
Thread-Index: AQHVL/ymVpzynCXU5k63SMVA/ahJHqa6ioEAgAD/xW0=
Date:   Fri, 5 Jul 2019 06:02:00 +0000
Message-ID: <B7B4BB465792624BAF51F33077E99065DC5DA1B0@ALA-MBD.corp.ad.wrs.com>
References: <B7B4BB465792624BAF51F33077E99065DC5D8E5D@ALA-MBD.corp.ad.wrs.com>,<20190704073200.GA2165@avx2>
In-Reply-To: <20190704073200.GA2165@avx2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.224.18.249]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Alexey,

Sounds excellent! Could you please drop a notifier of such?

For our usecase, the ipv6 is statically linked (=y) and then this happens way before
userland starts (thus no access to procfs) so I believe we should be able to continue
as is until we can replace with your proper patch. Agree?

Also still wonder about the others that creates directories in procfs net, that do not
call proc_net_mkdir().
My second patch changed to use proc_net_mkdir for dev_snmp6 directory, so if proc_net_mkdir is fixed
it should cover at least the ipv6 snmp counters. But I think there's other that could benefit of same?
Like :

net/netfilter/xt_hashlimit.c:   hashlimit_net->ipt_hashlimit = proc_mkdir("ipt_hashlimit", net->proc_net);
net/netfilter/xt_hashlimit.c:   hashlimit_net->ip6t_hashlimit = proc_mkdir("ip6t_hashlimit", net->proc_net);

Wouldn't those also want to be reflected by a net namespace change?
Just an example, there are others too.

BR,
Per

--
Per Hallsmark                        per.hallsmark@windriver.com
Senior Member Technical Staff        Wind River AB
Mobile: +46733249340                 Office: +46859461127
Torshamnsgatan 27                    164 40 Kista
________________________________________
From: Alexey Dobriyan [adobriyan@gmail.com]
Sent: Thursday, July 04, 2019 09:32
To: Hallsmark, Per
Cc: David S. Miller; linux-kernel@vger.kernel.org; netdev@vger.kernel.org
Subject: Re: [PATCH v2] let proc net directory inodes reflect to active net namespace

On Mon, Jul 01, 2019 at 11:06:34AM +0000, Hallsmark, Per wrote:

> +struct proc_dir_entry *proc_net_mkdir(struct net *net, const char *name,
> +                                   struct proc_dir_entry *parent)
> +{
> +     struct proc_dir_entry *pde;
> +
> +     pde = proc_mkdir_data(name, 0, parent, net);
> +     if (!pde)
> +             return NULL;
> +     pde->proc_dops = &proc_net_dentry_ops;

OK, this is buggy in a different way:
once proc_mkdir_data() returns, proc entry is live and should be fully
ready, so dentry operations should be glued before that.

I'll send proper patch.
