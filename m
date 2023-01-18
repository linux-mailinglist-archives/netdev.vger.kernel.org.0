Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD09B67214E
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbjARPbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjARPbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:31:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590E96A58
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674055860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qyi/LW55EkVK757BkAA9VDtsr0MGQ7QA8hOcylTonLk=;
        b=HdPN4d5PvPBjTBrnsO7KTiWmUvYGmG4YYQCkFWqxcessHo+1fDud8iIzIm3jJS6xK+uh1U
        /8oHg2FpVs14dLGU/2gmsjqhTnJQq/w/a8Rl8Gyh5ox+uCWS8s/Cr35HTiU3llmpvilcYq
        qTgHP/sdxuIuhniLM7K3PLchDn+lFnA=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-189-uyj1LMiePjOlTilJhParmQ-1; Wed, 18 Jan 2023 10:30:59 -0500
X-MC-Unique: uyj1LMiePjOlTilJhParmQ-1
Received: by mail-ot1-f69.google.com with SMTP id g33-20020a05683030a100b006865851595eso766270ots.21
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 07:30:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qyi/LW55EkVK757BkAA9VDtsr0MGQ7QA8hOcylTonLk=;
        b=tsw710z0VfotDZjyIt1iq236a8B9jzEj+tq9p2ftrOL0BZL4qaV4Bz8XgWzehyiQQq
         t4qSbahJ7cWWPJXkv4t7cP+qmAZsEybncWOuG2aoyX4dJqp53mOv12ulrY+wapN4nH2z
         6UnZMvK3rSko+8Ka7ydUh9iZisEQhFWPLA6RAOoZXLWCd3/QfwRYBbqo8DAl0/1/m91e
         ozsjqnQyoNoypxaPo+fddHvyl0tc+BMZ0suqWGsMNqvIVTZIELQ8mk4Dv7eNfSU+kL9d
         EzQjFapK/rp4slXvMQdtlSHORyYjPL+UHM7kAFlOvRKtRWlfVdG8Hfkt4CYbKKMYmJmO
         boYg==
X-Gm-Message-State: AFqh2kp3VlAMCH+a4P8vi4XoXlnt2Bsy7iutaNU64QLiz4uopedz5hd/
        5g3Nh5oAKfeiKAuJ44LsD6AQ85l+wMZ7Y+Cl12tQOGNI5pW++RIUXjTAGVkA6E6aYCtbUsriIPg
        EpwpaJZ2YzQrHGLO6
X-Received: by 2002:a05:6870:1614:b0:143:9d79:e911 with SMTP id b20-20020a056870161400b001439d79e911mr4735555oae.46.1674055858472;
        Wed, 18 Jan 2023 07:30:58 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvQD1ylfnV23NmH/gc49C3Ld8OeoMRj5utANK8r0Vbn9N2WPIQ/3o+cIGR6YM0+vkC8xg1Q6Q==
X-Received: by 2002:a05:6870:1614:b0:143:9d79:e911 with SMTP id b20-20020a056870161400b001439d79e911mr4735523oae.46.1674055858208;
        Wed, 18 Jan 2023 07:30:58 -0800 (PST)
Received: from halaney-x13s ([2600:1700:1ff0:d0e0::21])
        by smtp.gmail.com with ESMTPSA id l3-20020a056870218300b00152c52608dbsm18681737oae.34.2023.01.18.07.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:30:57 -0800 (PST)
Date:   Wed, 18 Jan 2023 09:30:54 -0600
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        edumazet@google.com, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ning Cai <ncai@quicinc.com>
Subject: Re: [PATCH net] net: stmmac: enable all safety features by default
Message-ID: <20230118153054.22vs2sqsuxifjpxg@halaney-x13s>
References: <20230116193722.50360-1-ahalaney@redhat.com>
 <20230117194348.3f098a18@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117194348.3f098a18@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 07:43:48PM -0800, Jakub Kicinski wrote:
> On Mon, 16 Jan 2023 13:37:23 -0600 Andrew Halaney wrote:
> > I've been working on a newer Qualcomm platform (sa8540p-ride) which has
> > a variant of dwmac5 in it. This patch is something Ning stumbled on when
> > adding some support for it downstream, and has been in my queue as I try
> > and get some support ready for review on list upstream.
> > 
> > Since it isn't really related to the particular hardware I decided to
> > pop it on list now. Please let me know if instead of enabling by default
> > (which the original implementation did and is why I went that route) a
> > message like "Safety features detected but not enabled in software" is
> > preferred and platforms are skipped unless they opt-in for enablement.
> 
> Could you repost and CC Wong Vee Khee, and maybe some other Intel folks
> who have been touching stmmac recently? They are probably the best to
> comment / review.
> 

Shoot, yes thank you I intended to do! Will resend.

- Andrew

