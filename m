Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F0A6EF292
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240277AbjDZKsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239943AbjDZKrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:47:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC3119B9
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 03:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682506022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q7eSG1klkAdyLEaNU1h7MS+MxhJ0DOqewp5Z8jQS+rk=;
        b=F1NAXP23RESFvqE515uSZfCqvlrPgo6WHQ+LKn1Vx/rnL7gR9IbT3buydMNvkKdBLW/qkN
        QrT/X5PpP0KK5j+IdmKII2hWNa6BhdlSgQAIjnv/e41DJjJrMFbfrbcWd8Sirrv2uggk4P
        K0ViDOY0f3sTZ1psLVSnbVEebn8CllE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-PURS2vhEND6C-UT1RYlDIw-1; Wed, 26 Apr 2023 06:47:01 -0400
X-MC-Unique: PURS2vhEND6C-UT1RYlDIw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94f2d9389afso620406566b.2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 03:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682506020; x=1685098020;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q7eSG1klkAdyLEaNU1h7MS+MxhJ0DOqewp5Z8jQS+rk=;
        b=HpbT9s6kNs+d6VL5SBkK9a8pD0KsWoh3uCtIwZTxvr5mArWXEYZptwn7Da/zzr/lVe
         gV1gIC3X5c5+CQzoquDhIPn2FNZc767dWJkuk62qGYTGMYmntXPlb/NHe7DLFCcCAFSt
         1gZuvjPlE4s42wDKIU8olWvxWHhWHYsRqz/gKgTuEneoF5cS9GCaWBBOW28tLa+LtQze
         0X3Yocv4IeisC0Fe3Cy9kgXjbtVO5yF6pPAYkAocYIp1Na2313aLqfkTlkKk9SymKUCN
         ZCViYqX012PoSEA83qvc1LiulzfPa0WoPsyAb9rR9FpYSc59vsTHVjUW0aMDSUqLZ9if
         kirA==
X-Gm-Message-State: AAQBX9cuMgROdtKSay2d/COKghFApBplZL0oBqbnjNWcMir9KXCxtAK9
        l+rbOmf2gXapjHvhmqR2YSXyUiGLrpIuGMmt72boT7O+RG6FFyxDmpk/xIleEs5ljstT7/j4Bkp
        +3+iV5xTdAPpFFoLT
X-Received: by 2002:a17:906:a84c:b0:947:c8d5:fb2a with SMTP id dx12-20020a170906a84c00b00947c8d5fb2amr17287731ejb.48.1682506019821;
        Wed, 26 Apr 2023 03:46:59 -0700 (PDT)
X-Google-Smtp-Source: AKy350bueCmxCjDSmFglv2TB/hZ+jA43sk3LCYfVFX9cQwRdfdOgUzEC5j8gS5n5MB/sN1wMbcmEvQ==
X-Received: by 2002:a17:906:a84c:b0:947:c8d5:fb2a with SMTP id dx12-20020a170906a84c00b00947c8d5fb2amr17287691ejb.48.1682506019416;
        Wed, 26 Apr 2023 03:46:59 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id lb16-20020a170907785000b0094ee700d8e4sm7946826ejc.44.2023.04.26.03.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 03:46:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 44A81AAA41C; Wed, 26 Apr 2023 12:46:58 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kal Conley <kal.conley@dectris.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Kal Conley <kal.conley@dectris.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v6 2/4] xsk: Support UMEM chunk_size > PAGE_SIZE
In-Reply-To: <20230412162114.19389-3-kal.conley@dectris.com>
References: <20230412162114.19389-1-kal.conley@dectris.com>
 <20230412162114.19389-3-kal.conley@dectris.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 26 Apr 2023 12:46:58 +0200
Message-ID: <87v8hij4yl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kal Conley <kal.conley@dectris.com> writes:

> Add core AF_XDP support for chunk sizes larger than PAGE_SIZE. This
> enables sending/receiving jumbo ethernet frames up to the theoretical
> maximum of 64 KiB. For chunk sizes > PAGE_SIZE, the UMEM is required
> to consist of HugeTLB VMAs (and be hugepage aligned). Initially, only
> SKB mode is usable pending future driver work.

So I still really don't understand why this is useful without the driver
support, and I think it's premature to merge it before that is present.
It also seems you didn't address any of the issues we discussed back on
v3, but instead just reposted (and didn't even Cc me, so I missed that
until now).

So, FWIW, consider this my:

Nacked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

