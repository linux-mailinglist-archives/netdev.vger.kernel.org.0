Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DFE54F93B
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 16:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382753AbiFQOej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 10:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiFQOei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 10:34:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DCB5000F;
        Fri, 17 Jun 2022 07:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zCYLBNrpsWXnOqcC5wJ/hD9iA4hBnMBniae3jFnLY4g=; b=V9GiLKMHEe+HEZjsJZ2Pb5P6ea
        d9D0pHgbo5JQRZoFL9HsbHI9Gdr4THYdrwvU9KtY2IcnhaclV//MKCurCrfsFBLpDYU+0XWi6zy00
        CStKpcL2cDfbTxFxY0Tf8zjpQNcUymWJ+YlY+fvPV1PcHXf0aNed562ttdg9wfTK0LHPZcFN+moY9
        tMgzajAbEMzya03pEkrkuFtIIygfEX8crLwpznvIEfcuhfXxChDJxrCJuIvuwz9tf/8Nlf/KxPo9t
        V2t5D5TgWuKJjFc4BX7Pk7tMX90ySuSVuqT+pniMH+AdHEAlxqqdkTfsfegVm8+GJB4P0Y2RxckVb
        hytS0s1Q==;
Received: from dhcp-077-249-017-003.chello.nl ([77.249.17.3] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o2D2o-002tnV-Hz; Fri, 17 Jun 2022 14:33:54 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 065709816B5; Fri, 17 Jun 2022 16:33:54 +0200 (CEST)
Date:   Fri, 17 Jun 2022 16:33:53 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        eperezma <eperezma@redhat.com>, Cindy Lu <lulu@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, conghui.chen@intel.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        netdev <netdev@vger.kernel.org>, pankaj.gupta.linux@gmail.com,
        Cristian Marussi <cristian.marussi@arm.com>,
        sudeep.holla@arm.com, Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH V6 8/9] virtio: harden vring IRQ
Message-ID: <YqyQ0bMF1EM8E6BW@worktop.programming.kicks-ass.net>
References: <CACGkMEtAQck7Nr6SP_pD0MGT3njnwZSyT=xPyYzUU3c5GNNM_w@mail.gmail.com>
 <CACGkMEvUFJkC=mnvL2PSH6-3RMcJUk84f-9X46JVcj2vTAr4SQ@mail.gmail.com>
 <20220613052644-mutt-send-email-mst@kernel.org>
 <CACGkMEstGvhETXThuwO+tLVBuRgQb8uC_6DdAM8ZxOi5UKBRbg@mail.gmail.com>
 <20220614114839-mutt-send-email-mst@kernel.org>
 <CACGkMEthExrqFNkOzLGwaffvHw=Tc3MXPtTTiRsnpFDGKPRP=A@mail.gmail.com>
 <20220616130945-mutt-send-email-mst@kernel.org>
 <CACGkMEuSX-wg-VQzVLRhE_9wmQVpCQo5cxQ-by3N6v7gaBNsrg@mail.gmail.com>
 <20220617013147-mutt-send-email-mst@kernel.org>
 <CACGkMEuaxpgGt38anCYfQfy_OOKf0HCmSonC7cBD9-jrgWQ+Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEuaxpgGt38anCYfQfy_OOKf0HCmSonC7cBD9-jrgWQ+Ow@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 03:26:16PM +0800, Jason Wang wrote:
> On Fri, Jun 17, 2022 at 1:36 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Jun 17, 2022 at 09:24:57AM +0800, Jason Wang wrote:
> > > On Fri, Jun 17, 2022 at 1:11 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Wed, Jun 15, 2022 at 09:38:18AM +0800, Jason Wang wrote:
> > > > > On Tue, Jun 14, 2022 at 11:49 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Jun 14, 2022 at 03:40:21PM +0800, Jason Wang wrote:
> > > > > > > On Mon, Jun 13, 2022 at 5:28 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, Jun 13, 2022 at 05:14:59PM +0800, Jason Wang wrote:
> > > > > > > > > On Mon, Jun 13, 2022 at 5:08 PM Jason Wang <jasowang@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Mon, Jun 13, 2022 at 4:59 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Mon, Jun 13, 2022 at 04:51:08PM +0800, Jason Wang wrote:
> > > > > > > > > > > > On Mon, Jun 13, 2022 at 4:19 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > > > > >
> > > > > > > > > > > > > On Mon, Jun 13, 2022 at 04:07:09PM +0800, Jason Wang wrote:
> > > > > > > > > > > > > > On Mon, Jun 13, 2022 at 3:23 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > On Mon, Jun 13, 2022 at 01:26:59PM +0800, Jason Wang wrote:
> > > > > > > > > > > > > > > > On Sat, Jun 11, 2022 at 1:12 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > > > On Fri, May 27, 2022 at 02:01:19PM +0800, Jason Wang wrote:
> > > > > > > > > > > > > > > > > > This is a rework on the previous IRQ hardening that is done for

Guys; have you heard about trimming emails on reply?
