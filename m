Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9D2508145
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 08:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350282AbiDTGji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 02:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348640AbiDTGjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 02:39:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE64F34668;
        Tue, 19 Apr 2022 23:36:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 616F3617D2;
        Wed, 20 Apr 2022 06:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7288C385A1;
        Wed, 20 Apr 2022 06:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650436607;
        bh=R56RE4aFvkqPZGVd/hDyRfNwHqmFG6X+wUFjItkexZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Etueqch0dQr9WeF/PuZNwLlZr40/aaQba//XEMXDxNUPVmTE8fibMEZ/mSBuQJAV1
         iO6MvnFaY4pkkHwvqVtpq4ge/rIvdlum1x9Tp6VQD9/PpNDxQ53s6hX5Hcsyiqfv2r
         kNAQ0icd3l54h/agDkwZ+hpfvFokBILKULHqu0CmAjwkeKilAmS/AspuDC9wLUjweL
         GXpQa8Tw/xrjolKej5BlQBcoDTPa1IYjsaQhqjllWpF8EQ/C+fkU4EtXdGILEzJazU
         vvvHOWEO1lfLMcK6UN1OAkRFUnx6knTwCgKPVniAo9fNQyi5ZhjGk7D18Nx1Qx99SO
         SEUmf19Uuadcg==
Date:   Wed, 20 Apr 2022 09:36:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     Michal Schmidt <mschmidt@redhat.com>, netdev@vger.kernel.org,
        Petr Oros <poros@redhat.com>,
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
Message-ID: <Yl+p+7C7JQDj1jt1@unreal>
References: <20220414163907.1456925-1-ivecera@redhat.com>
 <CADEbmW3eUAnvn4gvNxqjCMmO333-=OdObGhDXkrTbDwn0YkJDw@mail.gmail.com>
 <20220415174932.6c85d5ab@ceranb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415174932.6c85d5ab@ceranb>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 05:49:32PM +0200, Ivan Vecera wrote:
> On Fri, 15 Apr 2022 13:12:03 +0200
> Michal Schmidt <mschmidt@redhat.com> wrote:
> 
> > On Thu, Apr 14, 2022 at 6:39 PM Ivan Vecera <ivecera@redhat.com> wrote:
> > 
> > > Function ice_plug_aux_dev() assigns pf->adev field too early prior
> > > aux device initialization and on other side ice_unplug_aux_dev()
> > > starts aux device deinit and at the end assigns NULL to pf->adev.
> > > This is wrong and can causes a crash when ice_send_event_to_aux()
> > > call occurs during these operations because that function depends
> > > on non-NULL value of pf->adev and does not assume that aux device
> > > is half-initialized or half-destroyed.
> > >
> > > Modify affected functions so pf->adev field is set after aux device
> > > init and prior aux device destroy.
> > >  
> > [...]
> > 
> > > @@ -320,12 +319,14 @@ int ice_plug_aux_dev(struct ice_pf *pf)
> > >   */
> > >  void ice_unplug_aux_dev(struct ice_pf *pf)
> > >  {
> > > -       if (!pf->adev)
> > > +       struct auxiliary_device *adev = pf->adev;
> > > +
> > > +       if (!adev)
> > >                 return;
> > >
> > > -       auxiliary_device_delete(pf->adev);
> > > -       auxiliary_device_uninit(pf->adev);
> > >         pf->adev = NULL;
> > > +       auxiliary_device_delete(adev);
> > > +       auxiliary_device_uninit(adev);
> > >  }
> > >  
> > 
> > Hi Ivan,
> > What prevents ice_unplug_aux_dev() from running immediately after
> > ice_send_event_to_aux() gets past its "if (!pf->adev)" test ?
> > Michal
> 
> ice_send_event_to_aux() takes aux device lock. ice_unplug_aux_dev()
> calls auxiliary_device_delete() that calls device_del(). device_del()
> takes device_lock() prior kill_device(). So if ice_send_event_to_aux()
> is in progress then device_del() waits for its completion.

Not really, you nullify pf->adev without any lock protection and
ice_send_event_to_aux() will simply crash.

 CPU#1          	|   CPU#2
			| ice_send_event_to_aux
 ice_unplug_aux_dev()   | ...
 ...                    | 
 pf->adev = NULL;       | 
      			| device_lock(&pf->adev->dev); <--- crash here.

Thanks


> 
> Thanks,
> Ivan
> 
