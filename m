Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C1B28AAC5
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 23:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgJKVxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 17:53:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728605AbgJKVxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 17:53:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AFCC206E9;
        Sun, 11 Oct 2020 21:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602453219;
        bh=SBULuKCMc36h3ODIhXbL92t1ppZICLoOWVvCtFVFe3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jz8zYjC9B8u+Vm1XQqr1RxTdSfls717+Vt6D+TFjwUtGBwsq6IZFp7yrbcEtUpHlb
         y/prXPqG24BIfrKJzTcVMnYvyzZr0qq+S6POxlNXeupVaAemTjIW2k8FTr0sDUCDrN
         XOlNFkoqty9vh63ieRiRHsSO+BpuOq79MuN9uvJw=
Date:   Sun, 11 Oct 2020 14:53:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Andrew Gospodarek <gospo@broadcom.com>
Subject: Re: [PATCH net-next 3/9] bnxt_en: Set driver default message level.
Message-ID: <20201011145337.5264a0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLimUkSe489TibQsbUd2+BH-VHEoQw1cHhosni4C8EMWZog@mail.gmail.com>
References: <1602411781-6012-1-git-send-email-michael.chan@broadcom.com>
        <1602411781-6012-4-git-send-email-michael.chan@broadcom.com>
        <20201011123429.05e83141@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACKFLimUkSe489TibQsbUd2+BH-VHEoQw1cHhosni4C8EMWZog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 14:13:04 -0700 Michael Chan wrote:
> On Sun, Oct 11, 2020 at 12:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sun, 11 Oct 2020 06:22:55 -0400 Michael Chan wrote:  
> > > Currently, bp->msg_enable has default value of 0.  It is more useful
> > > to have the commonly used NETIF_MSG_DRV and NETIF_MSG_HW enabled by
> > > default.
> > >
> > > Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> > > Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>  
> >
> > This will add whole bunch of output for "RX buffer error 4000[45]", no?
> > That one needs to switch to a silent reset first, I'd think.  
> 
> The last round of net-next patches have made changes to reduce this
> noise already.  If the firmware supports the new  RING_MONITOR scheme,
> There will be no more messages.  The reset will be counted in a new
> ethtool -S counter only.
> 
> If the firmware is older and does not support the new scheme, we've
> changed the logging to warn_once() in addition to the ethtool -S
> counter.  There is no point in warning more than once.

I'm talking about bnxt_dbg_dump_states specifically. 

I'm looking at net-next:

 bnxt_rx_pkt
   bnxt_sched_reset
     set_bit(BNXT_RESET_TASK_SP_EVENT, &bp->sp_event);


 bnxt_sp_task
   bnxt_reset
     bnxt_reset_task
       bnxt_dbg_dump_states

