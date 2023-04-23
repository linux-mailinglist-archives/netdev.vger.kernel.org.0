Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC0F6EBD9B
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 09:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjDWHUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 03:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjDWHUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 03:20:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCCE1BE6
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 00:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682234362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nOfk5KVt03Kw/nxPJuFXIUc7M+oFb5UuYNKx4WZp95g=;
        b=BayY7JgwPUKoTnFHruRBrkOD49yx/0BNTo5kuPOwnef+ecOQI7Zs18AxRe4q+X9RCNDWwe
        P1+ObnC6vjR6TW9xRzAVABEoJJzCoE45iIKtSZaxwxBs62LqHQVrMj5kw3KoJ6X1mBU3cF
        2aeQJ0bfBNv/pRyV/gUPR+NtXwoHkFw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-m7NRMmIJN7mPvp1hsd4oWw-1; Sun, 23 Apr 2023 03:19:20 -0400
X-MC-Unique: m7NRMmIJN7mPvp1hsd4oWw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f080f9ea3eso11541095e9.1
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 00:19:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682234359; x=1684826359;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nOfk5KVt03Kw/nxPJuFXIUc7M+oFb5UuYNKx4WZp95g=;
        b=ObwdjYtsIKimxmmsiiInUfYKwIna6PeeVu6CnZm4Juex5C1TFZMop7z6IZJOJ3rvXV
         wo7v8p1440Ed9cagZh4TraKhEyKErq+CRCUg5bFFS8eFQLCk6YO49QctJSscnBbU2P1i
         RaS1+ifugA/pDd6mtNeHOjMexm/8pZ9x0xdZPWndtJOXyD2G32rY153JafcPPs6IVhi/
         EoCPYUlFG4v/L+oaTG+ND6oAwGiS181xSygpeb1D6QhP5Y+Fyu3ZxwidoyUA6dCQgCOO
         cIA/n+MMj4Eu+KWEBoL66U8XzNLAM64lnWSY+rVhCJCOzVy8OAIBkpbs8k+tNAh9BD6s
         7liQ==
X-Gm-Message-State: AAQBX9cu58ELxY2wgNTIjOm7h33BlQUsUBMXUPAZobUvL9XubWCo78Nw
        /ZesqF2fqi6ncSPkCWMbCpmgBrPg0V2BzMvesm/4uLbKkTpo2nHaUcT2lj3MrqBsJgW6T3fMNtR
        FAzQbnHAPN/HqjfsS
X-Received: by 2002:a1c:790e:0:b0:3f1:7288:1912 with SMTP id l14-20020a1c790e000000b003f172881912mr5053869wme.33.1682234359573;
        Sun, 23 Apr 2023 00:19:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350al0K0IJpL8RrXHGcCmLxmGOjejEQPiJFsouPKi82zaCtJVKp95uN3hEitLPfT62TTH3eSRFw==
X-Received: by 2002:a1c:790e:0:b0:3f1:7288:1912 with SMTP id l14-20020a1c790e000000b003f172881912mr5053855wme.33.1682234359214;
        Sun, 23 Apr 2023 00:19:19 -0700 (PDT)
Received: from redhat.com ([2.55.61.39])
        by smtp.gmail.com with ESMTPSA id z4-20020a05600c0a0400b003ef4cd057f5sm12633650wmp.4.2023.04.23.00.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 00:19:18 -0700 (PDT)
Date:   Sun, 23 Apr 2023 03:19:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Message-ID: <20230423031308-mutt-send-email-mst@kernel.org>
References: <20230417023911-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237BFB8BB3A3606CE6A408D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417030713-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723F3E6AE381AEC36D1AEFED49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417051816-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237705695AFD873DEE4530D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417073830-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417075645-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA90465186B5A8A5C001D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM0PR04MB4723FA90465186B5A8A5C001D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 06:51:46AM +0000, Alvaro Karsz wrote:
> > Yes that makes sense, it's architetural. We can disable ctrl vq though.
> 
> The problem here is that we know the vring size after calling virtnet_find_vqs, so the number of VQs already includes the control VQ.
> 
> Actually, many variables/settings that are initialized before we call virtnet_find_vqs may need modifications if we use small vrings.
> For example has_rss_hash_report, has_rss, hdr_len etc..
> 
> We could have a fixup function to fix everything after we discover that we are using small vrings, but, honestly, I think that this will be hard to maintain in the future, and I don't like this approach much.
> 
> The ideal thing will be to discover if we use small vrings in probe's beginning.
> 
> I'm looking for a way at the moment.

Hmm. I was wrong. There is no way to disable CVQ feature bit.

1. Reset the device.
2. Set the ACKNOWLEDGE status bit: the guest OS has notice the device.
3. Set the DRIVER status bit: the guest OS knows how to drive the device.
4. Read device feature bits, and write the subset of feature bits understood by the OS and driver to the
device. During this step the driver MAY read (but MUST NOT write) the device-specific configuration
fields to check that it can support the device before accepting it.
5. Set the FEATURES_OK status bit. The driver MUST NOT accept new feature bits after this step.
6. Re-read device status to ensure the FEATURES_OK bit is still set: otherwise, the device does not
support our subset of features and the device is unusable.
7. Perform device-specific setup, including discovery of virtqueues for the device, optional per-bus setup,
reading and possibly writing the device’s virtio configuration space, and population of virtqueues.
8. Set the DRIVER_OK status bit. At this point the device is “live”.


So features are confirmed before find vqs.

The rest of stuff can probably just be moved to after find_vqs without
much pain.

So if cvq is too small we can either
- probe but avoid using cvq
or
- fail probe

-- 
MST

