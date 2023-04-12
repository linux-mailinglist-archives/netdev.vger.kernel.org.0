Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25AC46DF53F
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjDLMaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjDLMaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:30:17 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC4D7696
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 05:29:57 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-504dfc87927so826114a12.0
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 05:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681302596; x=1683894596;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MLp10WEiVKKRfi0jPvUlHAptfbcw1jdZpFv7p0ceEMc=;
        b=fiko1kujM9EMpsIe8pKAFagHh9m6DO8hXPnkE34F9JJw1ZVbWKnzhuIyigxPgIe9bT
         mOdzvQtIqivAXnuTeumInAjKSXDkOsSdZDehT/8eRRNBp5trxGtLENMCpd0VDwd7LJjs
         hdWzdfn2cCG7Bhchj82AqR6FmV2J5ydn8Amo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681302596; x=1683894596;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MLp10WEiVKKRfi0jPvUlHAptfbcw1jdZpFv7p0ceEMc=;
        b=i2HPt9n+04YUvMyLz8ZB6KJR215KZyYA/x//b3CMNdQfUvAQhnXJsLS6dp5k82ADM2
         DhOjQKt1Ck3a9JQeC45+smpympzq5CXFfGZL+ZW+3rVnPsPe6E7iGNDhkoA+ziXo/SrE
         zd3V1xERbzk9ze9SLrnfYHF/ccdYiLGdL6XrLzAGstNJEIKcBctUI9vLCjM/ot0+gZx/
         oHux0iFMV5PGb8tCH0D1WeArFrWqoYPbt7DXeiDC1jhYhVpsQQfLyMv+pKLC1zdYQ10I
         6wKsuExzMgAUx08JMibljuurd4Tv6nCkqD+i9NWCOI2Bof6kypl8w9szmunv0MM4f0bI
         egbA==
X-Gm-Message-State: AAQBX9ePVqmeBpOLjENKZ0NEDUZjfX73XHUG74CVJmSsvOMAN3pCPAm6
        rQCcf58pjqQKesPisVbSABtOpoIFg9VBaO0+yS55feaxIyX3Ur9h
X-Google-Smtp-Source: AKy350YPuGvkISg3PavQb5IzwqvaGQHEAA7hmVuaX4QKgwnId8gqLgjbIJzsOQ/V96GwAbNVO0EJS8n4ceBOQPz/GfA=
X-Received: by 2002:a50:d71e:0:b0:504:9c1f:1c65 with SMTP id
 t30-20020a50d71e000000b005049c1f1c65mr5431631edi.6.1681302596073; Wed, 12 Apr
 2023 05:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230410121841.643254-1-kal.conley@dectris.com> <CAJ8uoz11tOSUK0+45K=L9q-yj3gyMCDJVPsOjawE+Wjbe2FSTQ@mail.gmail.com>
In-Reply-To: <CAJ8uoz11tOSUK0+45K=L9q-yj3gyMCDJVPsOjawE+Wjbe2FSTQ@mail.gmail.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Wed, 12 Apr 2023 14:34:40 +0200
Message-ID: <CAHApi-n9Vv-RvK-byG_hBiEqE+Apqb_Hvq-L1-yq3Q0LTtQDbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: Simplify xp_aligned_validate_desc implementation
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Perform the chunk boundary check like the page boundary check in
> > xp_desc_crosses_non_contig_pg(). This simplifies the implementation and
> > reduces the number of branches.
>
> Thanks for this simplification Kal. Just to check, does your change
> pass the xsk selftests, especially the INV_DESC test? If so, then you
> have my ack below.
>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

Yes, I ran the XSK selftests and they all PASSED.
