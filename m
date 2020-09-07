Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8007625F1FE
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 05:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgIGDNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 23:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgIGDNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 23:13:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1F7B20738;
        Mon,  7 Sep 2020 03:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599448393;
        bh=He9+H3T2F9dnuwg9dErWqMPAt+M3EfNYkfaCGX2BfNo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BR77ZI9DY5RZqGmKcCMCXR+ndhe1MllFr4iE/AYJFvEaXtbr7e5JAWjr+W0wCr6Vd
         rlE2zu5GRaaPYBxbZVmbGOY0xmH7fcBQpoI8ghaSbkki1RsDvOq0svJyJcYAjrdehl
         sbBYyKW4WhkigM/accxP/El1jwIhCX2uBZWJk/+0=
Date:   Sun, 6 Sep 2020 20:13:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net 2/2] bnxt_en: Fix NULL ptr dereference crash in
 bnxt_fw_reset_task()
Message-ID: <20200906201311.0873ad59@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLin=-9=2x0MFuRfXM1HwFQ7uZSZ4i0HymRZDBVKcnK73NA@mail.gmail.com>
References: <1599360937-26197-1-git-send-email-michael.chan@broadcom.com>
        <1599360937-26197-3-git-send-email-michael.chan@broadcom.com>
        <20200906122534.54e16e08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACKFLin=-9=2x0MFuRfXM1HwFQ7uZSZ4i0HymRZDBVKcnK73NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Sep 2020 15:07:02 -0700 Michael Chan wrote:
> On Sun, Sep 6, 2020 at 12:25 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > devlink can itself scheduler a recovery via:
> >
> >   bnxt_fw_fatal_recover() -> bnxt_fw_reset()
> >  
> 
> Yes, this is how it is initiated when we call devlink_health_report()
> to report the error condition.  From bnxt_fw_reset(), we use a
> workqueue because we have to go through many states, requiring
> sleeping/polling to transition through the states.
> 
> > no? Maybe don't make the devlink recovery path need to go via a
> > workqueue?  
> 
> Current implementation is going through a work queue.

What I'm saying is the code looks like this after this patch:

+	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	bnxt_cancel_sp_work(bp);
+	bp->sp_event = 0;
+
 	bnxt_dl_fw_reporters_destroy(bp, true);

It cancels the work, _then_ destroys the reporter. But I think the
reported can be used to schedule a recovery from command line. So the
work may get re-scheduled after it has been canceled.

devlink_nl_cmd_health_reporter_recover_doit() -> bnxt_fw_fatal_recover() ->
  bnxt_fw_reset() -> bnxt_queue_fw_reset_work()

What am I missing?
