Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5D84EE9EF
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 10:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244654AbiDAIt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 04:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244221AbiDAIt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 04:49:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 35A9D3CFCB
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 01:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648802857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=37yAvQTIEV1IvNK0QI/IF+EVq5TLZBtgSkNUfD0vZVo=;
        b=S2TTZGqeW2szXRCPL5VwjoG28KuX9qhhcvhqAmMbQXNbjoMnZvVqrIGFiLuFGag9qhpfo6
        5WqW0SDUSJeqfUIk5+kuQ3AAImG5EYe84GMA8rdJ2jr0AlctCqc8wX2Uqsqmm2AI55D3Ti
        YSvDPCXi7dUtLbrt7txlNfgKgoQCkII=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-cqP0x8lDMBuv4wQq1Nu4iA-1; Fri, 01 Apr 2022 04:47:33 -0400
X-MC-Unique: cqP0x8lDMBuv4wQq1Nu4iA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9C36101A52C;
        Fri,  1 Apr 2022 08:47:32 +0000 (UTC)
Received: from ceranb (unknown [10.40.192.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E73405E194A;
        Fri,  1 Apr 2022 08:47:30 +0000 (UTC)
Date:   Fri, 1 Apr 2022 10:47:30 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Brett Creeley <brett@pensando.io>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, mschmidt <mschmidt@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        poros <poros@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net] ice: Fix incorrect locking in
 ice_vc_process_vf_msg()
Message-ID: <20220401104730.44cd443e@ceranb>
In-Reply-To: <CO1PR11MB5089888D13802251F6830A8ED6E19@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220331105005.2580771-1-ivecera@redhat.com>
        <YkWpNVXYEBo/u3dm@boxer>
        <YkWp5JJ9Sp6UCTw7@boxer>
        <CAFWUkrTzE87bduD431nu11biHi78XFitUWQfiwcU6_4UPU9FBg@mail.gmail.com>
        <CO1PR11MB5089888D13802251F6830A8ED6E19@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Mar 2022 19:59:11 +0000
"Keller, Jacob E" <jacob.e.keller@intel.com> wrote:

> > -----Original Message-----
> > From: Brett Creeley <brett@pensando.io>
> > Sent: Thursday, March 31, 2022 9:33 AM
> > To: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> > Cc: ivecera <ivecera@redhat.com>; netdev@vger.kernel.org; moderated
> > list:INTEL ETHERNET DRIVERS <intel-wired-lan@lists.osuosl.org>; mschmidt
> > <mschmidt@redhat.com>; open list <linux-kernel@vger.kernel.org>; poros
> > <poros@redhat.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> > <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>; Keller, Jacob E
> > <jacob.e.keller@intel.com>
> > Subject: Re: [Intel-wired-lan] [PATCH net] ice: Fix incorrect locking in
> > ice_vc_process_vf_msg()
> > 
> > On Thu, Mar 31, 2022 at 6:17 AM Maciej Fijalkowski
> > <maciej.fijalkowski@intel.com> wrote:  
> > >
> > > On Thu, Mar 31, 2022 at 03:14:32PM +0200, Maciej Fijalkowski wrote:  
> > > > On Thu, Mar 31, 2022 at 12:50:04PM +0200, Ivan Vecera wrote:  
> > > > > Usage of mutex_trylock() in ice_vc_process_vf_msg() is incorrect
> > > > > because message sent from VF is ignored and never processed.
> > > > >
> > > > > Use mutex_lock() instead to fix the issue. It is safe because this  
> > > >
> > > > We need to know what is *the* issue in the first place.
> > > > Could you please provide more context what is being fixed to the readers
> > > > that don't have an access to bugzilla?
> > > >
> > > > Specifically, what is the case that ignoring a particular message when
> > > > mutex is already held is a broken behavior?  
> > >
> > > Uh oh, let's
> > > CC: Brett Creeley <brett@pensando.io>  
> >  
> 
> Thanks for responding, Brett! :)
>  
> > My concern here is that we don't want to handle messages
> > from the context of the "previous" VF configuration if that
> > makes sense.
> >   
> 
> Makes sense. Perhaps we need to do some sort of "clear the existing message queue" when we initiate a reset?

I think this logic is already there... Function ice_reset_vf() (running under cfg_lock) sets default allowlist
during reset (these are VIRTCHNL_OP_GET_VF_RESOURCES, VIRTCHNL_OP_VERSION, VIRTCHNL_OP_RESET_VF).
Function ice_vc_process_vf_msg() currently processed message whether is allowed or not so any spurious messages
there were sent by VF prior reset should be dropped already.

> 
> > It might be best to grab the cfg_lock before doing any
> > message/VF validating in ice_vc_process_vf_msg() to
> > make sure all of the checks are done under the cfg_lock.
> >   
> 
> Yes that seems like it should be done.

Yes, the mutex should be placed prior ice_vc_is_opcode_allowed() call to serialize accesses to allowlist.
Will send v2.

Thanks,
Ivan

