Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F0F6DD775
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 12:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjDKKGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 06:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjDKKGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 06:06:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FA544AD
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 03:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681207512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MQJyPgI1aYYzA2uRs3ijvvK+cnKO4iZfEOcreRoPXjs=;
        b=dZ1ALtNfGMDvbpae11AC+3j3x70FCEIPfXMibPhUV6givTasDbma9MNsFeS6dBColYB8P7
        d/iyK5Bz6d68W+ocibYz14LiMDCMKXfd2MyGv0HhQYqf7WvexBsu8M6QQSavzHtlhQn4Nm
        cp3oigzjNijPZYF5NsG1GeCyem7AxTw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-Ukc-KiADPJmpE55iNXqKsw-1; Tue, 11 Apr 2023 06:05:11 -0400
X-MC-Unique: Ukc-KiADPJmpE55iNXqKsw-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-5e965c54827so5467986d6.0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 03:05:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681207511; x=1683799511;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MQJyPgI1aYYzA2uRs3ijvvK+cnKO4iZfEOcreRoPXjs=;
        b=iTtpOkb30WjV1VxAsmvM/MJShO/YJXMe0m+UTYPQKiUY4yNQ/8o/4HGHwQP299fx/k
         sCZ2MhG0UPUAIcsTCISjxEUj/bjiXwbRXoESEUaHz0//A67FhOwpwt4ZVEWpvy8+JbR7
         olDFcf9jVxThveeLVJUPU0K8fEW9CN3p4id/n6znYGKMtcXAD8i5IQiu3tZkkU5u9eLC
         KFHv/R/YaLBD9PZuXa2wxSWY0Zp8PhTv4PuFcx7g4vj1m71OyNxFUlZRj3diEgPot1xU
         7xYyG3GI/ShD92VH8PgluEv1kypSLEH5p+vY4fxlWJ765lk329WMNeYeZPWgI9dXVJWR
         E4bA==
X-Gm-Message-State: AAQBX9d3Ek+2EzNmYeDTOtzJpQmdZif4irHL/flZYXdfXpp15Jdwk8tr
        lUuHNiQChk+Y0Hx8+H871Xu9iQ0uapIKS2rRE3R3w2i0QN7PzpyiXopDqbo3DLf3eBB2fATwQOU
        +84CQAcCRNuxYhRvW
X-Received: by 2002:a05:6214:c2f:b0:5e0:84a9:2927 with SMTP id a15-20020a0562140c2f00b005e084a92927mr21797619qvd.4.1681207510952;
        Tue, 11 Apr 2023 03:05:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350YmLFiGBKxZDQs5rlvP04KZi2wea8aPk/MtNoc+mqDg0UQ3dbzvIp555xXOrBZYvyYg8te9XA==
X-Received: by 2002:a05:6214:c2f:b0:5e0:84a9:2927 with SMTP id a15-20020a0562140c2f00b005e084a92927mr21797594qvd.4.1681207510694;
        Tue, 11 Apr 2023 03:05:10 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-96.dyn.eolo.it. [146.241.239.96])
        by smtp.gmail.com with ESMTPSA id y7-20020a0ce807000000b005e96ebf9bbdsm2443728qvn.5.2023.04.11.03.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 03:05:10 -0700 (PDT)
Message-ID: <e8b3646710d5fbedbe73449e5a1a7bd83fb1fa61.camel@redhat.com>
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: add remove callback
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Radu Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Tue, 11 Apr 2023 12:05:07 +0200
In-Reply-To: <20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230406095904.75456-1-radu-nicolae.pirea@oss.nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-04-06 at 12:59 +0300, Radu Pirea (OSS) wrote:
> Unregister PTP clock when the driver is removed.
> Purge the RX and TX skb queues.
>=20
> Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
> CC: stable@vger.kernel.org # 5.15+
> Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>

Andrew: my understanding is that a connected phy, maintains a reference
to the relevant driver via phydev->mdio.dev.driver->owner, and such
reference is dropped by phy_disconnect() via phy_detach().

So remove can invoked only after phy_disconnect

Does the above sounds reasonable/answer your question?

Thanks

Paolo

