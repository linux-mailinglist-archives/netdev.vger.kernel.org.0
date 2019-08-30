Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881E3A4060
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbfH3WRO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Aug 2019 18:17:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42830 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbfH3WRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:17:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EDEDA154FFFDD;
        Fri, 30 Aug 2019 15:17:11 -0700 (PDT)
Date:   Fri, 30 Aug 2019 15:17:11 -0700 (PDT)
Message-Id: <20190830.151711.704306282464276122.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     snelson@pensando.io, netdev@vger.kernel.org
Subject: Re: [PATCH v6 net-next 07/19] ionic: Add basic adminq support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830151604.1a7dd276@cakuba.netronome.com>
References: <20190829155251.3b2d86c7@cakuba.netronome.com>
        <bad39320-8e67-e280-5e35-612cbdc49b6f@pensando.io>
        <20190830151604.1a7dd276@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 30 Aug 2019 15:17:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri, 30 Aug 2019 15:16:04 -0700

> On Fri, 30 Aug 2019 12:31:07 -0700, Shannon Nelson wrote:
>> On 8/29/19 3:52 PM, Jakub Kicinski wrote:
>> > On Thu, 29 Aug 2019 11:27:08 -0700, Shannon Nelson wrote:  
>> >> +static void ionic_lif_qcq_deinit(struct ionic_lif *lif, struct ionic_qcq *qcq)
>> >> +{
>> >> +	struct ionic_dev *idev = &lif->ionic->idev;
>> >> +	struct device *dev = lif->ionic->dev;
>> >> +
>> >> +	if (!qcq)
>> >> +		return;
>> >> +
>> >> +	ionic_debugfs_del_qcq(qcq);
>> >> +
>> >> +	if (!(qcq->flags & IONIC_QCQ_F_INITED))
>> >> +		return;
>> >> +
>> >> +	if (qcq->flags & IONIC_QCQ_F_INTR) {
>> >> +		ionic_intr_mask(idev->intr_ctrl, qcq->intr.index,
>> >> +				IONIC_INTR_MASK_SET);
>> >> +		synchronize_irq(qcq->intr.vector);
>> >> +		devm_free_irq(dev, qcq->intr.vector, &qcq->napi);  
>> > Doesn't free_irq() basically imply synchronize_irq()?  
>> 
>> The synchronize_irq() waits for any threaded handlers to finish, while 
>> free_irq() only waits for HW handling.  This helps makes sure we don't 
>> have anything still running before we remove resources.
> 
> mm.. I'm no IRQ expert but it strikes me as surprising as that'd mean
> every single driver would always have to run synchronize_irq() on
> module exit, no?
> 
> I see there is a kthread_stop() in __free_irq(), you sure it doesn't
> wait for threaded IRQs?

I'm pretty sure it does.
