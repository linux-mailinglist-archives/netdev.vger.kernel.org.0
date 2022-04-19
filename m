Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B88D50705F
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353318AbiDSO0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353305AbiDSOZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:25:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEBF32AE33
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650378189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6dg830iBfEr5I+C1yC730bVzeRQr31mDv92ikL2x34U=;
        b=WCRi81ZTICEonPd9VcYl3OiOGHKFr9QglwmTRslUmgVpBlvVivsbSPKQpEXxNv0noWJrAO
        a59I83Dy5SHbl25VytdtjFfAO7Z4x+u0mm2kZ9bbj7Yf7cqg8gbzrRli8ZVWDo2Vwi9KF+
        5P85i+Vp7i3gek/myJRT+c/NjqwKhrU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-K-9C8fr3NselcOhsA6WL1Q-1; Tue, 19 Apr 2022 10:23:05 -0400
X-MC-Unique: K-9C8fr3NselcOhsA6WL1Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E2BC86B8A3;
        Tue, 19 Apr 2022 14:23:05 +0000 (UTC)
Received: from ceranb (unknown [10.40.194.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71E941400C2D;
        Tue, 19 Apr 2022 14:23:03 +0000 (UTC)
Date:   Tue, 19 Apr 2022 16:23:02 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Fei Liu <feliu@redhat.com>, <netdev@vger.kernel.org>,
        <mschmidt@redhat.com>, "Brett Creeley" <brett@pensando.io>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH net] ice: Protect vf_state check by
 cfg_lock in ice_vc_process_vf_msg()
Message-ID: <20220419162302.60378ede@ceranb>
In-Reply-To: <607248b2-bfb2-08a2-3d17-67c5c28840fc@intel.com>
References: <20220413072259.3189386-1-ivecera@redhat.com>
        <YlldFriBVkKEgbBs@boxer>
        <YlldsfrRJURXpp5d@boxer>
        <248da3d7-cb00-14b6-12f0-6bb9fda6d532@intel.com>
        <20220416133043.08b4ee74@ceranb>
        <607248b2-bfb2-08a2-3d17-67c5c28840fc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Apr 2022 11:10:30 -0700
Tony Nguyen <anthony.l.nguyen@intel.com> wrote:

> > If you want to leave the code as is and remove this from the patch
> > let me know and I will send v2.  
> 
> The change itself looks ok to me, but for net patches, we should fix the 
> issue without introducing other changes. A v2 without this change would 
> be great; feel free to submit this change to -next after I've applied 
> the v2 for this patch.
> 
> Thanks,
> 
> Tony
Agree, sending v2.

Thanks,
Ivan

