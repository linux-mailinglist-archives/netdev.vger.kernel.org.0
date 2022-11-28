Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B4363AD54
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 17:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbiK1QJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 11:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiK1QJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 11:09:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAB86479
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 08:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669651734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o5GDhDm4JU5Mpg4R2Z+CBFjZxBl2rw5tuzFFcShscK4=;
        b=SuT8MPbIarpvZB/cVGF2ckxKeFJcZHFRgl7KSgO5rxN8zypgeWFm4V3yWT2Kqvk7NGSPcq
        tfZO1pX82+NKrozfz1WOXsRAmJhQuJQw95hg0FdUdmnhtZPXguZzAhgYGFlxgJjPKHMdNP
        0znVq4qREvrWAIq8xZfxu54NOLMpQc8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-FKkPDEQVNM-xwVN1bu6d1Q-1; Mon, 28 Nov 2022 11:08:52 -0500
X-MC-Unique: FKkPDEQVNM-xwVN1bu6d1Q-1
Received: by mail-qk1-f198.google.com with SMTP id bk30-20020a05620a1a1e00b006fb2378c857so21049317qkb.18
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 08:08:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o5GDhDm4JU5Mpg4R2Z+CBFjZxBl2rw5tuzFFcShscK4=;
        b=V6tYGDLPDmH0d5jH7polaV3FOBipyczTMy9BWRbL7OHj6OiOVUkTiGP5qPONH6FfGT
         tEAhmkrN+c8gxFgAitbGP/SFWncVe6fs6o8WxbTpa3J5hkA8PKnitaWUsdPgVoEVVbys
         9i5lKbR9RM64HqcZcp2fwlR1KVxKHcHCvwVYlE4DSLv3Uk2s6tH+VZxArovk8GlA2m3e
         DfQIXKpj1QWVZVIoqFRtMsuxyvMqLuyCVlGehNJGlBvkn0R4nB0ZMDUv88AeW0vcPhNW
         /nbi2cMbZAVFqwmGYoyCxZI+tSZCn3id5nw7iN4HREJ00ror80raN22gVzBuaEC9o2dj
         SO2w==
X-Gm-Message-State: ANoB5pkz673IF72Xg/XAg/tuX4Gm64TyU2GgFw+8nAWvyOjYIrVMaTuw
        CwayHet28nzHX/XxuFmYHtTkj0G9nM080n1nb788qrukZV4Ap3xAPUiD8vdqbDgqi45D/JeSJ6Y
        r3ph53qc9Xdajclzp
X-Received: by 2002:ac8:1084:0:b0:3a5:2a3d:a953 with SMTP id a4-20020ac81084000000b003a52a3da953mr49632422qtj.231.1669651731926;
        Mon, 28 Nov 2022 08:08:51 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5hsj+OOKt/nThtdfdxd77LM70mzsjwOpfcLwMvqfiyIe6U7hroglHO4w0baBFHmNNhVYCMkQ==
X-Received: by 2002:ac8:1084:0:b0:3a5:2a3d:a953 with SMTP id a4-20020ac81084000000b003a52a3da953mr49632397qtj.231.1669651731688;
        Mon, 28 Nov 2022 08:08:51 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id z27-20020ac87cbb000000b00359961365f1sm7070155qtv.68.2022.11.28.08.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 08:08:51 -0800 (PST)
Message-ID: <1951bd409f86287fcffce41e22026ed09605f9b2.camel@redhat.com>
Subject: Re: [PATCH net-next] selftests/net: add csum offload test
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        Willem de Bruijn <willemb@google.com>
Date:   Mon, 28 Nov 2022 17:08:48 +0100
In-Reply-To: <20221128140210.553391-1-willemdebruijn.kernel@gmail.com>
References: <20221128140210.553391-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 2022-11-28 at 09:02 -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Test NIC hardware checksum offload:
> 
> - Rx + Tx
> - IPv4 + IPv6
> - TCP + UDP
> 
> Optional features:
> 
> - zero checksum 0xFFFF
> - checksum disable 0x0000
> - transport encap headers
> - randomization
> 
> See file header for detailed comments.
> 
> Expected results differ depending on NIC features:
> 
> - CHECKSUM_UNNECESSARY vs CHECKSUM_COMPLETE
> - NETIF_F_HW_CSUM (csum_start/csum_off) vs NETIF_F_IP(V6)_CSUM
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>

I'm wondering if we could hook this into the self-tests list with a
suitable wrapper script, e.g. searching for a NIC exposing the loopback
feature, quering the NETIF_F_HW_CSUM/NETIF_F_IP(V6)_CSUM bit via
ethtool and guessing CHECKSUM_UNNECESSARY vs CHECKSUM_COMPLETE via the
received packet.

If the host lacks a suitable device, the test is skipped. WDYT?

Thanks!

Paolo

