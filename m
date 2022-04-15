Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AB5502D55
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbiDOPwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237165AbiDOPwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:52:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9028512AD8
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650037779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xuws84Z0jp4NihhTFNZTBNeED6UNObMvI7eL6H7Gs80=;
        b=UmE5+yHVbZx8AciShgn1WOXIIZ3ykuoWsnFlGQxqFFcM/E0RLLjC6FOVW4SB73Y2oVssvt
        hn5/OSqqUmBUQ/pigdjGQT0roo0P7H+6ObPBPhLethU0ioI35qudeY5nRY73bYTIQksiv9
        UMBlxJGx7eGrd4f6gNAirVG3y42X2Lg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-IMKEHtUKOHa8JFhxqrqjmA-1; Fri, 15 Apr 2022 11:49:36 -0400
X-MC-Unique: IMKEHtUKOHa8JFhxqrqjmA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 965C51014A61;
        Fri, 15 Apr 2022 15:49:35 +0000 (UTC)
Received: from ceranb (unknown [10.40.194.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0114404E4B0;
        Fri, 15 Apr 2022 15:49:33 +0000 (UTC)
Date:   Fri, 15 Apr 2022 17:49:32 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Michal Schmidt <mschmidt@redhat.com>
Cc:     netdev@vger.kernel.org, Petr Oros <poros@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] ice: Fix race during aux device (un)plugging
Message-ID: <20220415174932.6c85d5ab@ceranb>
In-Reply-To: <CADEbmW3eUAnvn4gvNxqjCMmO333-=OdObGhDXkrTbDwn0YkJDw@mail.gmail.com>
References: <20220414163907.1456925-1-ivecera@redhat.com>
        <CADEbmW3eUAnvn4gvNxqjCMmO333-=OdObGhDXkrTbDwn0YkJDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Apr 2022 13:12:03 +0200
Michal Schmidt <mschmidt@redhat.com> wrote:

> On Thu, Apr 14, 2022 at 6:39 PM Ivan Vecera <ivecera@redhat.com> wrote:
> 
> > Function ice_plug_aux_dev() assigns pf->adev field too early prior
> > aux device initialization and on other side ice_unplug_aux_dev()
> > starts aux device deinit and at the end assigns NULL to pf->adev.
> > This is wrong and can causes a crash when ice_send_event_to_aux()
> > call occurs during these operations because that function depends
> > on non-NULL value of pf->adev and does not assume that aux device
> > is half-initialized or half-destroyed.
> >
> > Modify affected functions so pf->adev field is set after aux device
> > init and prior aux device destroy.
> >  
> [...]
> 
> > @@ -320,12 +319,14 @@ int ice_plug_aux_dev(struct ice_pf *pf)
> >   */
> >  void ice_unplug_aux_dev(struct ice_pf *pf)
> >  {
> > -       if (!pf->adev)
> > +       struct auxiliary_device *adev = pf->adev;
> > +
> > +       if (!adev)
> >                 return;
> >
> > -       auxiliary_device_delete(pf->adev);
> > -       auxiliary_device_uninit(pf->adev);
> >         pf->adev = NULL;
> > +       auxiliary_device_delete(adev);
> > +       auxiliary_device_uninit(adev);
> >  }
> >  
> 
> Hi Ivan,
> What prevents ice_unplug_aux_dev() from running immediately after
> ice_send_event_to_aux() gets past its "if (!pf->adev)" test ?
> Michal

ice_send_event_to_aux() takes aux device lock. ice_unplug_aux_dev()
calls auxiliary_device_delete() that calls device_del(). device_del()
takes device_lock() prior kill_device(). So if ice_send_event_to_aux()
is in progress then device_del() waits for its completion.

Thanks,
Ivan

