Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338F872F4C
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 14:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfGXM4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 08:56:02 -0400
Received: from nautica.notk.org ([91.121.71.147]:51183 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbfGXM4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 08:56:02 -0400
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 29525C009; Wed, 24 Jul 2019 14:56:00 +0200 (CEST)
Date:   Wed, 24 Jul 2019 14:55:45 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 9p: Fix possible null-pointer dereferences in
 p9_cm_event_handler()
Message-ID: <20190724125545.GA12982@nautica>
References: <20190724103948.5834-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190724103948.5834-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jia-Ju Bai wrote on Wed, Jul 24, 2019:
> In p9_cm_event_handler(), there is an if statement on 260 to check
> whether rdma is NULL, which indicates that rdma can be NULL.
> If so, using rdma->xxx may cause a possible null-pointer dereference.

The final dereference (complete(&rdma->cm_done) line 285) has been here
from the start, so we would have seen crashes by now if rdma could be
null at this point.

Let's do it the other way around and remove the useless "if (rdma)" that
has been here from day 1 instead ; I basically did the same with
c->status a few months ago (from a coverity report)...


That said, please note that 'rdma checked for null in this event->event
== RDMA_CM_EVENT_DISCONNECTED branch' does not mean rdma can be null in
other branches.
static analysis does not say anything more than the final complete()
should also have a check if the previous one has, but nothing about the
other cases in the switch.


Thanks,
-- 
Dominique
