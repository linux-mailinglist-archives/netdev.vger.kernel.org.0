Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C2158143A
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 15:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbiGZNdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 09:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238840AbiGZNdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 09:33:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 94FBE29838
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 06:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658842377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WtWQ8CNn+Fnnva2d20TsPDZ8W5JHmwzYgkn9YlTdzgc=;
        b=CyX8RAhHmBjqeNjkTtgj5g5MnQrwjc1iOP2HYmLMqMDm9T+r/3lbUwldtKLDaXJzGo3S0B
        0fG6Dmnca/B7ZlNtyoNNrcOVjeVDentBXb2e0xWgZ2SW1kMg7vjCsd8rcpK/9qU6Iw4rL+
        xl4CR9s5yjiGe5r0QXzqcfnah5tWLss=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-cUbWdzpSNPGjanxlBg2MaQ-1; Tue, 26 Jul 2022 09:32:56 -0400
X-MC-Unique: cUbWdzpSNPGjanxlBg2MaQ-1
Received: by mail-wm1-f69.google.com with SMTP id v11-20020a1cf70b000000b003a318238826so5420083wmh.2
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 06:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WtWQ8CNn+Fnnva2d20TsPDZ8W5JHmwzYgkn9YlTdzgc=;
        b=uh6iqxPP2loKDMFervA6RUKo+5tUM/gmybW6mjOUMkD6laQ6pzVtjbL4OBQfGsEXlN
         vJOgZLPn9NkYj+YcEGLzdty+c+Z2WJxHKytlMxAGE6X7IrNIn+gERr0rUD40+KzOh2yA
         ++0LZN3e7v1TAaAma+KXOWrQeQZdzwL/Y9C36oxTgHi0NdSCsF7oKvWN8Vwj+aHcnQ68
         CdMeIrUWEb+pORB8w1pNLkCEcBP76viI6PdgWj2ivuEJaqVp4cNj3OZdl5AekEg4GzNn
         PBLVWQGfVbboQau8oa29MlzBusgTOgXx/E5WOwgKNSPLGZtMrLL4yQ86BpTI1aYhdIOB
         dAUw==
X-Gm-Message-State: AJIora83kr5EpsM9QuDxgwRturaQP3wGPdeEZx72njXHxXaEZtGokBsz
        JTJKqRWwSB5WYEEkwCbZFyYftREIP3ZmgwVJflZ2sipdoHrd6atyWars2EZk7NgiN6U6YvHJp4Y
        OTKAF4V/R05LwD+s7
X-Received: by 2002:a05:6000:1848:b0:21e:8fa5:e5f4 with SMTP id c8-20020a056000184800b0021e8fa5e5f4mr4971121wri.691.1658842375092;
        Tue, 26 Jul 2022 06:32:55 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1seod5VTkYCW39M9rc4UPwnXONNrr1hgnpHtWa2fn3gj5t9CPMBsQTdbEsAGjHN8jXVV42QxA==
X-Received: by 2002:a05:6000:1848:b0:21e:8fa5:e5f4 with SMTP id c8-20020a056000184800b0021e8fa5e5f4mr4971105wri.691.1658842374830;
        Tue, 26 Jul 2022 06:32:54 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id c15-20020adfe70f000000b0021bbf6687b1sm17837677wrm.81.2022.07.26.06.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 06:32:54 -0700 (PDT)
Message-ID: <04967132ceb556048db399b1cc8ec065365fa62d.camel@redhat.com>
Subject: Re: [net PATCH 4/5] octeontx2-af: Fix mcam entry resource leak
From:   Paolo Abeni <pabeni@redhat.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>, davem@davemloft.net,
        kuba@kernel.org, sgoutham@marvell.com, netdev@vger.kernel.org
Date:   Tue, 26 Jul 2022 15:32:53 +0200
In-Reply-To: <1658672209-8837-5-git-send-email-sbhatta@marvell.com>
References: <1658672209-8837-1-git-send-email-sbhatta@marvell.com>
         <1658672209-8837-5-git-send-email-sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-07-24 at 19:46 +0530, Subbaraya Sundeep wrote:
> The teardown sequence in FLR handler returns if no NIX LF
> is attached to PF/VF because it indicates that graceful
> shutdown of resources already happened. But there is a
> chance of all allocated MCAM entries not being freed by
> PF/VF. Hence free mcam entries even in case of detached LF.
> 
> Fixes: c554f9c1574e("octeontx2-af: Teardown NPA, NIX LF upon receiving FLR")

The above fixes tag need a space between the commit hash and the '('.
Could you adjust that and post a new version?

Thanks!

Paolo

