Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29D54C0128
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbiBVSW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiBVSWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:22:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 965F8CFBBB
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645554142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wpBwJl6c6s7sx3w93zOGpJgVfvC/ipdRSEUJaReqDhs=;
        b=OTPXr1o81pdgHSka3/Yk7x4vwLYFmV8i5ofVvY2WFpT2VBSXN4Lb6ankh2Applkv6EsJ8O
        xgprgAU669mImkAJ4hb/Ou+gbcBIxmI4U8Aggdn/JL3es4Vf4ye226xfV8fv8/J1OFP+5z
        JnJcEk+QIZB8Cf/caGKVI+MW8TD/yH0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-QflFvAqZOSWLleMcbvM1cA-1; Tue, 22 Feb 2022 13:22:16 -0500
X-MC-Unique: QflFvAqZOSWLleMcbvM1cA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4ED01100C610;
        Tue, 22 Feb 2022 18:22:15 +0000 (UTC)
Received: from [10.22.11.128] (unknown [10.22.11.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 221A987548;
        Tue, 22 Feb 2022 18:22:14 +0000 (UTC)
Message-ID: <a1baa10e-2c73-1fdd-0228-820310455dd5@redhat.com>
Date:   Tue, 22 Feb 2022 13:22:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [syzbot] WARNING in cpuset_write_resmask
Content-Language: en-US
To:     Tejun Heo <tj@kernel.org>,
        syzbot <syzbot+568dc81cd20b72d4a49f@syzkaller.appspotmail.com>
Cc:     cgroups@vger.kernel.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, lizefan.x@bytedance.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000264b2a05d44bca80@google.com>
 <0000000000008f71e305d89070bb@google.com> <YhUc10UcAmot1AJK@slm.duckdns.org>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <YhUc10UcAmot1AJK@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/22 12:26, Tejun Heo wrote:
> (cc'ing Waiman and quoting whole body)
>
> Hello, Waiman.
>
> It looks like it's hitting
>
>   WARN_ON(!is_in_v2_mode() && !nodes_equal(cp->mems_allowed, cp->effective_mems))
>
> Can you take a look?

My preliminary analysis is that the warning may be caused by my commit 
1f1562fcd04a ("cgroup/cpuset: Don't let child cpusets restrict parent in 
default hierarchy") since the merge branch e5313968c41b is missing the 
fix commit d068eebbd482 ("cgroup/cpuset: Make child cpusets restrict 
parents on v1 hierarchy"). I believe the problem should be gone once the 
merge branch is updated to a later upstream baseline.

Cheers,
Longman

