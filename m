Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890084EB2FA
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 19:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbiC2R5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 13:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240039AbiC2R5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 13:57:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B09C375E5B
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 10:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648576531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kGMPBJ//O6psjBzV1vVr4GcYMJAivjV7NQg3N1Zfl8Y=;
        b=Cd82R2C0YPzyHM+8S+NAzSLJCUlCav66xWoQmY0b82enRwEqiHmj6rVvBFPfCm1pH0yzH2
        /g5iSi5pEC3iAdt91JrzmGulGgYMcOETkh8L9IwDtOUnu3qIXeU+FieRn4FedrV8C5+Xw5
        VFGbhZp2PpmQvIKT+AAmDNv+CFYJA3g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592--kr4w_ZuMVKcTYXJskxZ_Q-1; Tue, 29 Mar 2022 13:55:28 -0400
X-MC-Unique: -kr4w_ZuMVKcTYXJskxZ_Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26A4D899ED4;
        Tue, 29 Mar 2022 17:55:27 +0000 (UTC)
Received: from ceranb (unknown [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2258401E2A;
        Tue, 29 Mar 2022 17:55:23 +0000 (UTC)
Date:   Tue, 29 Mar 2022 19:55:22 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, poros@redhat.com, mschmidt@redhat.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>
Subject: Re: [PATCH net] ice: Fix logic of getting XSK pool associated with
 Tx queue
Message-ID: <20220329195522.63d332fb@ceranb>
In-Reply-To: <YkL0wfgyCq5s8vdu@boxer>
References: <20220329102752.1481125-1-ivecera@redhat.com>
        <YkL0wfgyCq5s8vdu@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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

On Tue, 29 Mar 2022 14:00:01 +0200
Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:

> Thanks for this fix! I did exactly the same patch yesterday and it's
> already applied to bpf tree:
> 
> https://lore.kernel.org/bpf/20220328142123.170157-5-maciej.fijalkowski@intel.com/T/#u
> 
> Maciej

Thanks for info... Nice human race condition ;-)

I.

