Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7BC6E96C0
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjDTOQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbjDTOQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:16:15 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB0C40EE
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 07:16:12 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 588551C0004;
        Thu, 20 Apr 2023 14:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1682000171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RbmklkEWQtGCkLagrFjvI4aFTnblupi62AYD6+1ULz8=;
        b=EXW6ByD6dSXk9HO3HbrDnqdIK9hdGB6FRDua/rNfFSScZL/2lQGg6SIwg0ZLPFh0BIE76h
        OLKthXls+52b8zLIqH1EqRcPcF3JDdZ8u+diOtiIcn9ypbI+6q2agXI+dhc1wufeGvQYOg
        IMiDdleHmEDoj/Qagq1cluH+Dpga4Z3dXkN1XfXR/Izk6mc244HHJyIV5JCewJZqSYBEx/
        iCYuEfiFj9vIdc6XKg1PMUMNKcd3t+z/ZQDcH/oU6Y4b+5P98ETV0mMbBPxTAY7/KGiQ1T
        VembnlfCB8dZBdJIZ+i5IXGCsF10/+RaOktnbHwGf+dYvuUaNovrNMjsCtxU0Q==
Date:   Thu, 20 Apr 2023 16:16:09 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, kuba@kernel.org,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 1/5] Add NDOs for hardware timestamp get/set
Message-ID: <20230420161609.2b65a1ed@kmaincent-XPS-13-7390>
In-Reply-To: <CAP5jrPH__dJpGepM6Vs45PH+Pppx6KOVnUDS5f44DGeyseghfQ@mail.gmail.com>
References: <20230405063144.36231-1-glipus@gmail.com>
        <20230405123130.5wjeiienp5m6odhr@skbuf>
        <CAP5jrPH__dJpGepM6Vs45PH+Pppx6KOVnUDS5f44DGeyseghfQ@mail.gmail.com>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Apr 2023 09:54:27 -0600
Max Georgiev <glipus@gmail.com> wrote:

> On Wed, Apr 5, 2023 at 6:31=E2=80=AFAM Vladimir Oltean <vladimir.oltean@n=
xp.com>
> wrote:
> >
> > On Wed, Apr 05, 2023 at 12:31:44AM -0600, Maxim Georgiev wrote: =20
> > > Current NIC driver API demands drivers supporting hardware timestampi=
ng
> > > to implement handling logic for SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs.
> > > Handling these IOCTLs requires dirivers to implement request parameter
> > > structure translation between user and kernel address spaces, handling
> > > possible translation failures, etc. This translation code is pretty m=
uch
> > > identical across most of the NIC drivers that support SIOCGHWTSTAMP/
> > > SIOCSHWTSTAMP.
> > > This patch extends NDO functiuon set with ndo_hwtstamp_get/set
> > > functions, implements SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTL translation
> > > to ndo_hwtstamp_get/set function calls including parameter structure
> > > translation and translation error handling.
> > >
> > > This patch is sent out as RFC.
> > > It still pending on basic testing.


Just wondering about the status of this patch series.
Do you want hardware testing before v4?
As there were several reviews, I was waiting for the next version before do=
ing
any testing but if you ask for it to move forward I can deal with it.
Also, I have cadence macb MAC which supports time stamping, I can adapt your
last patch on e1000e to macb driver but I would appreciate if you do it
beforehand.
