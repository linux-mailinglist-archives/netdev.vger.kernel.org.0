Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A806EBF10
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 13:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjDWLHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 07:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDWLHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 07:07:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A7B10C6
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 04:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682248018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g1lbsLzGIKBrnxXJSYGJKVy6ieEQPX6tVrFGk22ivD8=;
        b=KBvT5WuTymayJdKYiah2r7hTcaj0qqu4I1nbZJgA90MR70nN7D/MLUAgYHsA8kpPKDubTA
        xLS8ERtqYojImic7RSf/6ECb1Vd9lkP+4Gvm2LR2j2Y3FQjc7JQ1X0oJAcTa0UF8Wvt2i+
        SuBV30Lg/sLQt17hguJZS8ZeyI/FWAY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-3L8QVgn8NBG1HKxtf4svpw-1; Sun, 23 Apr 2023 07:06:57 -0400
X-MC-Unique: 3L8QVgn8NBG1HKxtf4svpw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-2fbb99cb303so1168722f8f.1
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 04:06:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682248016; x=1684840016;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g1lbsLzGIKBrnxXJSYGJKVy6ieEQPX6tVrFGk22ivD8=;
        b=NB9ZMCisvlD7aVb/wQgrBaPj4TpyC+rHwsDyHJJuUeHnZYvQcDATAjDkIhwBUnMzV3
         MM0LJdhH9xCcTu3Y/KyUNnHpAUQQaaWp+8VwE6+0zeaHIbj2s1KusHuXsfIfweZmstYG
         fKWe5BnIhFVg8QVxlfgj01vtsx6YtXsVgBv/TGvyws9aqNYzn2b1fiRw8tG4zu+Y+/R9
         5YVHGPfZPrOvncNb7x3Rr56rMpKv6Z8IBH2EGWdo0WbnP7DyxTTmPkmTKjdVXu/hOj8n
         RZNjD6Pm88avZtM+fU3ZegZHLNogGaKbHMfVZXiJFkBMxfbsPPAfRrHSUat4x7ffBZHx
         LxDw==
X-Gm-Message-State: AAQBX9fKp2BoZxrx1THzVgaU/GA7RCnBPSzcRsR2YYfAUMLlnd7XrFfM
        1FFp0LPSatwZP61DLMdLrGVgYqm0f/eiCfrKzCnhgAwupo+2L4/+XIt1yCCcGj+iEhPpCbT9X+B
        gMsxMOK8Si1AmZdEQ
X-Received: by 2002:adf:e391:0:b0:2ff:f37:9d18 with SMTP id e17-20020adfe391000000b002ff0f379d18mr8443649wrm.58.1682248016036;
        Sun, 23 Apr 2023 04:06:56 -0700 (PDT)
X-Google-Smtp-Source: AKy350YH8SS0VuiRXjohEkEQZc8MmQshWjBCHCvdHkztK8dbkfkMtdUR3z5eGaMnzjCodqZBlxcrXw==
X-Received: by 2002:adf:e391:0:b0:2ff:f37:9d18 with SMTP id e17-20020adfe391000000b002ff0f379d18mr8443639wrm.58.1682248015697;
        Sun, 23 Apr 2023 04:06:55 -0700 (PDT)
Received: from redhat.com ([2.55.61.39])
        by smtp.gmail.com with ESMTPSA id j32-20020a05600c1c2000b003f173987ec2sm12802917wms.22.2023.04.23.04.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 04:06:55 -0700 (PDT)
Date:   Sun, 23 Apr 2023 07:06:51 -0400
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
Message-ID: <20230423065132-mutt-send-email-mst@kernel.org>
References: <20230417030713-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723F3E6AE381AEC36D1AEFED49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417051816-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237705695AFD873DEE4530D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417073830-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417075645-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA90465186B5A8A5C001D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423031308-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47233B680283E892C45430BCD4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM0PR04MB47233B680283E892C45430BCD4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 07:52:10AM +0000, Alvaro Karsz wrote:
> > Hmm. I was wrong. There is no way to disable CVQ feature bit.
> > 
> > 1. Reset the device.
> > 2. Set the ACKNOWLEDGE status bit: the guest OS has notice the device.
> > 3. Set the DRIVER status bit: the guest OS knows how to drive the device.
> > 4. Read device feature bits, and write the subset of feature bits understood by the OS and driver to the
> > device. During this step the driver MAY read (but MUST NOT write) the device-specific configuration
> > fields to check that it can support the device before accepting it.
> > 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new feature bits after this step.
> > 6. Re-read device status to ensure the FEATURES_OK bit is still set: otherwise, the device does not
> > support our subset of features and the device is unusable.
> > 7. Perform device-specific setup, including discovery of virtqueues for the device, optional per-> bus setup,
> > reading and possibly writing the device’s virtio configuration space, and population of virtqueues.
> > 8. Set the DRIVER_OK status bit. At this point the device is “live”.
> > 
> > 
> > So features are confirmed before find vqs.
> > 
> > The rest of stuff can probably just be moved to after find_vqs without
> > much pain.
> > 
> Actually, I think that with a little bit of pain :)
> If we use small vrings and a GRO feature bit is set, Linux will need to allocate 64KB of continuous memory for every receive descriptor..

Oh right. Hmm. Well this is same as big packets though, isn't it?


> Instead of failing probe if GRO/CVQ are set, can we just reset the device if we discover small vrings and start over?
> Can we remember that this device uses small vrings, and then just avoid negotiating the features that we cannot support?


We technically can of course. I am just not sure supporting CVQ with just 1 s/g entry will
ever be viable.

-- 
MST

