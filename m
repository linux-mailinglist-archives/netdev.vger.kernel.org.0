Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CC651366E
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 16:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347975AbiD1OM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiD1OM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:12:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 719B65371D
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 07:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651154981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VU/g/6adn+3HZiPBUlaLXpCnn/ytwolQHw+K+XFjUgY=;
        b=BZ4UWh0oGkwUTHDk6qcj1TJFqnhNmK2BhlGxgnTi36xVLg1YCxB7l1ZMD3zlaiu+1TK/Vw
        V63osOU3X20cAxlhDpMlwfscoEHvJ9rIgBeXl6kXGyjzRt2UVWaFr4hFcNlNvQssHwBNgb
        a/+ZL/cz13EiZti9HZSe9m4uHoPvlUg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-WM-o6l93NomB35-kWZCkYw-1; Thu, 28 Apr 2022 10:09:40 -0400
X-MC-Unique: WM-o6l93NomB35-kWZCkYw-1
Received: by mail-wm1-f71.google.com with SMTP id p32-20020a05600c1da000b00393fbf9ab6eso3480204wms.4
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 07:09:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VU/g/6adn+3HZiPBUlaLXpCnn/ytwolQHw+K+XFjUgY=;
        b=IpiIr1L2FhfQf+Aadv6dv+X1n1aMq+b9bLLuGSl58KJaeUfMgTsxs2fzJKHF9dDBHq
         fe1nlBW58N6EcPlA7zilev+pSOpHUbSiiJgB5DbdnlU7kXq1Vvx1wTuhf3cQxR0qjl1c
         YdjBeSaaw7LS/bQX5k3vZqVZGLSmyE22hgEt5Ff/YzhXjSlPUr6V+yI2LVwh20Cr9FYu
         NPehNK6bSJ3IBiJNXbSCsy+Dk50OQP9+OmCMbje9+bYRnLYPCeVSHRb7rVBCewQjMy+4
         PMEfSrUmCabP8mRgk+k7YWPRzMDu+BSIXWqIhhvmWFmr9xvE3oW7fcElun/L+h5LQ/v5
         3WPA==
X-Gm-Message-State: AOAM531Y5o0xGr2EPY1Mlph1wscOSQdUgxFHwcvs0IJtjAT31oeripFD
        d+KWcN5X+P9l7gobWWJzZjLUBfVQRCfRdiV3/2dUbpED7yli8StDGTDoV4lUF6pOe2i73ZPtLes
        62zGsK2zIymB1rWu+
X-Received: by 2002:adf:ee4c:0:b0:20a:e668:b939 with SMTP id w12-20020adfee4c000000b0020ae668b939mr10770719wro.523.1651154978800;
        Thu, 28 Apr 2022 07:09:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYEXrCDh17OVyVJrMHReMDh2nx5QQA/qJmvMcJgS06lVB9a+h1o00gnmRaDcGh7EL9Au5MCg==
X-Received: by 2002:adf:ee4c:0:b0:20a:e668:b939 with SMTP id w12-20020adfee4c000000b0020ae668b939mr10770703wro.523.1651154978621;
        Thu, 28 Apr 2022 07:09:38 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-13.dyn.eolo.it. [146.241.96.13])
        by smtp.gmail.com with ESMTPSA id v6-20020adfa1c6000000b0020add25571bsm9855395wrv.42.2022.04.28.07.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 07:09:38 -0700 (PDT)
Message-ID: <229c169ccf8fdbf7fc826901982f1f15e86f3d17.camel@redhat.com>
Subject: Re: [PATCH net-next 02/11] udp/ipv6: refactor udpv6_sendmsg udplite
 checks
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Date:   Thu, 28 Apr 2022 16:09:37 +0200
In-Reply-To: <33dfdf2119c86e35062f783d405bedec2fde2b4c.1651071843.git.asml.silence@gmail.com>
References: <cover.1651071843.git.asml.silence@gmail.com>
         <33dfdf2119c86e35062f783d405bedec2fde2b4c.1651071843.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-04-28 at 11:56 +0100, Pavel Begunkov wrote:
> Don't save a IS_UDPLITE() result in advance but do when it's really
> needed, so it doesn't store/load it from the stack. Same for resolving
> the getfrag callback pointer.

It's quite unclear to me if this change brings really any performance
benefit. The end results will depend a lot on the optimization
performed by the compiler, and IMHO the code looks better before this
modifications.

Paolo

