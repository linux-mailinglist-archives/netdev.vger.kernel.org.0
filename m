Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DC3633F2B
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbiKVOql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiKVOqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:46:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751713C6F3
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669128341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fsk8lK1WZRQU/UZ9z9wF0cgfgcye32uUCeIAZWJu+G8=;
        b=BWKtCE0GHZG2KmmeS/VU09I5dP8HkyG13+QHdV6yGXlXdmXbEMYpjv2r4Wbj7newY6rvoc
        5KxI0yIVNpJ0RlsazMueTkVP4fEiniSTo/K89+JxF34Rl9Ua6TLF+JejE3O89EQt9yY9v1
        UaMtE0tv0Bij9RZmNX1bjTN3SsJBtT4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-372-qSKzoE9XP16FTP5A8EXvew-1; Tue, 22 Nov 2022 09:45:40 -0500
X-MC-Unique: qSKzoE9XP16FTP5A8EXvew-1
Received: by mail-qt1-f199.google.com with SMTP id fz10-20020a05622a5a8a00b003a4f466998cso14780931qtb.16
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:45:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fsk8lK1WZRQU/UZ9z9wF0cgfgcye32uUCeIAZWJu+G8=;
        b=0QbOlPvOxMaWfMBjmdFE9qYXf7EWA2JqCpeWcY8P3TteDbMdEUCJgr1sIqvZh3CCht
         GzC3yGW+9Rv9bYetEQ/gY5sMI/0RiwyJXh13VXVMyp98XD7xYk/f7XjdPtxGdJXZ9bIO
         0xSQgQ3x/POvRWZqvTBWvqVgXte8dxhn3YBS+l0IHJRBPtlkhqj+gJRkxRQ9bUBKrq6w
         jrCN7xg/HEFNHDPx/QF4f452UBAD7SzfNmztJtSO27cLi/LlimilVT3ufW5xHwKbkMi6
         aFPeeQ9nj9n4nthNPU1n59ue/CCkGPLagciXrTi5w5KHg8VUuzi6N+OFdM9xw4YpTSfj
         7d+A==
X-Gm-Message-State: ANoB5pmeGz7E0JrTUk4JK4BbOc+Mi9M1FijeUx8F0M0nFIIWtc2rPXcX
        1a+F85aUpb+FudutlCV0K7yFoE+Rb8ncfG65l7cG3/sLg8bZoWQ0kd338Ru9jxC2wsjw0mMbhwz
        3GLZrnNmr3+l8t778
X-Received: by 2002:a05:6214:2c1f:b0:4c6:a598:4fba with SMTP id lc31-20020a0562142c1f00b004c6a5984fbamr3559302qvb.109.1669128340110;
        Tue, 22 Nov 2022 06:45:40 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4sT+9GO6rCCDeZuoCM4ESitr28a4vZ41vYnM9Xlcil3b+82C888e2UG6BQpNHKoBjjojQ3jQ==
X-Received: by 2002:a05:6214:2c1f:b0:4c6:a598:4fba with SMTP id lc31-20020a0562142c1f00b004c6a5984fbamr3559276qvb.109.1669128339875;
        Tue, 22 Nov 2022 06:45:39 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id bm3-20020a05620a198300b006ecfb2c86d3sm10181194qkb.130.2022.11.22.06.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 06:45:39 -0800 (PST)
Message-ID: <5718ba71a8755040f61ed7b2f688b1067ca56594.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] bonding: fix link recovery in mode 2 when
 updelay is nonzero
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Date:   Tue, 22 Nov 2022 15:45:35 +0100
In-Reply-To: <1fe036eb-5207-eccd-0cb3-aa22f5d130ce@redhat.com>
References: <cover.1668800711.git.jtoppins@redhat.com>
         <cb89b92af89973ee049a696c362b4a2abfdd9b82.1668800711.git.jtoppins@redhat.com>
         <38fbc36783d583f805f30fb3a55a8a87f67b59ac.camel@redhat.com>
         <1fe036eb-5207-eccd-0cb3-aa22f5d130ce@redhat.com>
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

On Tue, 2022-11-22 at 08:36 -0500, Jonathan Toppins wrote:
> On 11/22/22 05:59, Paolo Abeni wrote:
> > Hello,
> > 
> > On Fri, 2022-11-18 at 15:30 -0500, Jonathan Toppins wrote:
> > > Before this change when a bond in mode 2 lost link, all of its slaves
> > > lost link, the bonding device would never recover even after the
> > > expiration of updelay. This change removes the updelay when the bond
> > > currently has no usable links. Conforming to bonding.txt section 13.1
> > > paragraph 4.
> > > 
> > > Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> > 
> > Why are you targeting net-next? This looks like something suitable to
> > the -net tree to me. If, so could you please include a Fixes tag?
> > 
> > Note that we can add new self-tests even via the -net tree.
> > 
> 
> I could not find a reasonable fixes tag for this, hence why I targeted 
> the net-next tree.

When in doubt I think it's preferrable to point out a commit surely
affected by the issue - even if that is possibly not the one
introducing the issue - than no Fixes as all. The lack of tag will make
more difficult the work for stable teams.

In this specific case I think that:

Fixes: 41f891004063 ("bonding: ignore updelay param when there is no active slave")

should be ok, WDYT? if you agree would you mind repost for -net?

Thanks,

Paolo

