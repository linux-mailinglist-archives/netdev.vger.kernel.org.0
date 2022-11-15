Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE19629C3A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiKOOjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiKOOjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:39:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACC2140B1
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 06:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668523092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tgM9yBaibwMrsZ9xdO1WAh2Xif4sqr+hPAuzkTHUCqI=;
        b=aMffMpsv4D87Rgi+Tnsf6NoDAvl2+1ozQYe1PEGS4ijt0LUslllbiVPavm9QmpkNDHDsrz
        WBbVLSdJLh0QAJLNf5u5dtmf2aIDSTvpVR7Wtln07VEkuiu8Jrs5BNCXUt46E0ujTL3rlv
        lSc1L8XVK0xH30saGtw30+OLNAbYhZM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-596-xhK7-sH5NrypmtNEJJstyQ-1; Tue, 15 Nov 2022 09:38:10 -0500
X-MC-Unique: xhK7-sH5NrypmtNEJJstyQ-1
Received: by mail-qt1-f199.google.com with SMTP id ay12-20020a05622a228c00b003a52bd33749so10266146qtb.8
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 06:38:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tgM9yBaibwMrsZ9xdO1WAh2Xif4sqr+hPAuzkTHUCqI=;
        b=NrVaiitKw4E4TP3U4hsi/HmTNP7OJp4OYmsTkCWcK0O6Lsed1+TWuN5p/ZdKK4Dw+O
         ve6an0bB0OVb7LQf2nt6lpn3Qv4MPVdQWZBT7mdz5G4Rfh4ZRMrZ1okjIG5eSNhiAIK5
         YVJEy7kSy9X6jA/kkGsO3vclDmJPu1Wq7w8GnmDXw1qM1mhXAJuQAq6Eh2v9fvkXK940
         nSiteZpFnsiAS4/7OibXTi+xFQcWCLyKuORyQoQjaI0pXcpduN+YNcHh7aW33MPAK0AN
         G5bTEWGW+rzH6pMJbK6BUuIibW3hNA7ix2dQ8emp2u6YO5SNOatgf5ewC8egREF2Z7K6
         UPxg==
X-Gm-Message-State: ANoB5pmXdUNeeNXqCRcVuLQh47tQLvgAz7+3XfdnWAMazFqJA/v7qpYO
        9wNFN7xEOSfrZS8fuTNBupsf0a7bc6/SXbTxc786YcAmqcJ6Lgg1pqVx3zQ5Ll5fNfxgSY2fJ9p
        XtIISrolt9tD28/23
X-Received: by 2002:a05:6214:15ce:b0:4bc:22ff:39ce with SMTP id p14-20020a05621415ce00b004bc22ff39cemr16799737qvz.91.1668523089759;
        Tue, 15 Nov 2022 06:38:09 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4Ugs0MnizyLhOd/gDTLlV5AAwZ2bECHUhV9BMK2FxYla92o4Le2yIt56mBxiPiY7Jnxsq37A==
X-Received: by 2002:a05:6214:15ce:b0:4bc:22ff:39ce with SMTP id p14-20020a05621415ce00b004bc22ff39cemr16799718qvz.91.1668523089475;
        Tue, 15 Nov 2022 06:38:09 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id f2-20020ac87f02000000b003a4c3c4d2d4sm7333875qtk.49.2022.11.15.06.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 06:38:08 -0800 (PST)
Message-ID: <9facd5682e29fa5e02062c8f665d9c2370a16fdb.camel@redhat.com>
Subject: Re: [PATCH net-next] net: phy: mscc: macsec: do not copy encryption
 keys
From:   Paolo Abeni <pabeni@redhat.com>
To:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com
Cc:     sd@queasysnail.net, netdev@vger.kernel.org
Date:   Tue, 15 Nov 2022 15:38:06 +0100
In-Reply-To: <20221114092033.34405-1-atenart@kernel.org>
References: <20221114092033.34405-1-atenart@kernel.org>
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

Hello,

On Mon, 2022-11-14 at 10:20 +0100, Antoine Tenart wrote:
> Instead of calling memzero_explicit on the key when freeing a flow,
> let's simply not copy the key in the first place as it's only used when
> a new flow is set up.
> 
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
> 
> Following
> https://lore.kernel.org/all/20221108153459.811293-1-atenart@kernel.org/T/
> refactor the MSCC PHY driver not to make a copy the encryption keys.

The patch LGTM, but would you mind including into the commit message a
reference to the -net commit, so that the dependency is there to
simplify eventual backports?

Thanks!

Paolo

