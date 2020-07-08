Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1F32184DF
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 12:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgGHKXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 06:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbgGHKXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 06:23:07 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42574C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 03:23:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a02:8010:6359:1:21b:21ff:fe6a:7e96])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 9ECC87D370;
        Wed,  8 Jul 2020 11:23:06 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1594203786; bh=04p9755MyyJl201V605Mv4wukH+/V8IKTd8TXFgevaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PbQGb7Y/W6pqMRm/mOczkc20MhMRqsMRhy36BYEGELgEBkRr8NVDOjdPKdsXtHdpr
         gUlzL4VfVPfZLDSRPGTdMRQi0KzapsSpSbz+6VyuTBxAfuFtT7KUJDkJQRZXnXIEvw
         rAE5fgueQLZhYhH6ejLQy0il1e5k8RZ6hy7wzQDfrhvz/Xqyc9CkZKgwR8ysqmhgl+
         FlcRvCsVlHUSs82hhUwm0Rk+kIT7LXcZwdy75WwT+UOulQa0QO77lMVKHWHOto+BlP
         LT0WaGxd3su+NqjulfEZoZsShktdWOBL5RaVLnri+nNg67UgAtm+HydgS6fQDzxPs0
         G0MuZSsl0Q/Uw==
Date:   Wed, 8 Jul 2020 11:23:06 +0100
From:   James Chapman <jchapman@katalix.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        gnault@redhat.com
Subject: Re: [PATCH net] l2tp: add sk_reuseport checks to l2tp_validate_socket
Message-ID: <20200708102306.GB26371@katalix.com>
References: <20200706121259.GA20199@katalix.com>
 <20200706.124536.774178117550894539.davem@davemloft.net>
 <20200707183128.owsu62mnxp3k6lae@kafai-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707183128.owsu62mnxp3k6lae@kafai-mbp>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On  Tue, Jul 07, 2020 at 11:31:28 -0700, Martin KaFai Lau wrote:
> On Mon, Jul 06, 2020 at 12:45:36PM -0700, David Miller wrote:
> > From: James Chapman <jchapman@katalix.com>
> > Date: Mon, 6 Jul 2020 13:12:59 +0100
> > 
> > > The crash occurs in the socket destroy path. bpf_sk_reuseport_detach
> > > assumes ownership of sk_user_data if sk_reuseport is set and writes a
> > > NULL pointer to the memory pointed to by
> > > sk_user_data. bpf_sk_reuseport_detach is called via
> > > udp_lib_unhash. l2tp does its socket cleanup through sk_destruct,
> > > which fetches private data through sk_user_data. The BUG_ON fires
> > > because this data has been corrupted.
> > 
> > The ownership of sk_user_data has to be handled more cleanly.
> > 
> > BPF really has no business taking over this as it is for the protocols
> > to use and what L2TP is doing is quite natural and normal.  Exactly
> > what sk_user_data was designed to be used for.
> > 
> > I'm not applying this, please take this up with the BPF folks.  They
> > need to store their metadata elsewhere.
> Thanks for the report.
> 
> The sk_user_data is used when a sk is added to the bpf's reuseport_sockarray.
> Before it can be added, the bpf side does check if the sk_user_data has already been
> used or not.  It is the similar check like other usages on sk_user_data.
> 
> The missing part is the reuseport_detach_sock() should check if a
> sk is currently in a reuseport_sockarray before calling bpf_sk_reuseport_detach().
> It can be solved by remembering if a sk is added to the reuseport_sockarray.
> I will work on a fix by doing this.

Thanks Martin.
