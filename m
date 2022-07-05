Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E0D566303
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 08:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiGEGRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 02:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiGEGRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 02:17:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6C0AB4BD
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 23:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657001851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MbYxVaIyDUhA5oPU13aBpn943FX8jDmN8TJKAwAcUCo=;
        b=GHVSejHKbH5VxpeHrQmhAPX2oQJc7xb041iWjxdwo87cvDacJchRDK5yWDWZygeiTHneGZ
        szH3IZg1ct/qr/VeuB6uI7teMQedHKXinKuzJTcmB+Khy98QGrX0wGrhz6TnS3MXCZvTlr
        o2yO2iIUnkVI2jME2FxBKk5dRSCRLjw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-kPVyYtU_Ncyy_gA4zWUJHg-1; Tue, 05 Jul 2022 02:17:27 -0400
X-MC-Unique: kPVyYtU_Ncyy_gA4zWUJHg-1
Received: by mail-wr1-f70.google.com with SMTP id s1-20020a5d69c1000000b0021b9f3abfebso1603671wrw.2
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 23:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MbYxVaIyDUhA5oPU13aBpn943FX8jDmN8TJKAwAcUCo=;
        b=Zxe7FDtK65EjvIlBbsJgobUp9kVDxg2yb0UW1AqheiEhMnIg/ru6sGJkCEJ6if3ubF
         qqTwHB0m+LDMM18vBKSGTqtoWnp/ra8krwFR3gfoZp/Eu7qPweFArqp0z32jf7JDVm1i
         jwq2dSY2kkEehK+61zm8cOA3npm+l2clJOTFCjyCuUiDJK4T9DkJ3kz9JJ43Rb7tOoXr
         cC+8HqzTO2FGhNUnDYdNc9W6jMVtg2Brc0SCpJ/ntpUBuBYvn/ZKd6navLaHvkN1Kk0L
         HdXk9mx/ov5XNjtlqScg9WkVwaBUE9kBHxiCjfl2mcAlc826/MQi96raKkBn6p+twhAP
         JoiA==
X-Gm-Message-State: AJIora+PeeVuoeZNYxaR2+0zK4lAu4b2BSvz2dcLKVBIlmFYTsfk5v1u
        0mUHz/6MDxSuXabNY663xXi9RBFTzX7fL0m4WOaWO2JK8E/2NpTWS+4DmscXL7a5VwMPRzZv0KW
        umC1KbHe1O7jQYHmp
X-Received: by 2002:a05:600c:1412:b0:3a1:6e8f:f18f with SMTP id g18-20020a05600c141200b003a16e8ff18fmr34488319wmi.9.1657001846645;
        Mon, 04 Jul 2022 23:17:26 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ul1fyFE62hxf1n1f4Ud2jXJAhFm/mPgf3uSTeNAYbENWRggVwIrsOB1i6VugYyuIwroW7d9A==
X-Received: by 2002:a05:600c:1412:b0:3a1:6e8f:f18f with SMTP id g18-20020a05600c141200b003a16e8ff18fmr34488300wmi.9.1657001846446;
        Mon, 04 Jul 2022 23:17:26 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id b15-20020adff90f000000b0021b90cc66a1sm32048000wrr.2.2022.07.04.23.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 23:17:26 -0700 (PDT)
Message-ID: <cbd7e14b3496229497ae49edbb68c04d4c1d7449.camel@redhat.com>
Subject: Re: [PATCH net-next] eth: remove neterion/vxge
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        corbet@lwn.net, jdmason@kudzu.us, vburru@marvell.com,
        jiawenwu@trustnetic.com, linux-doc@vger.kernel.org
Date:   Tue, 05 Jul 2022 08:17:24 +0200
In-Reply-To: <20220701144010.5ae54364@kernel.org>
References: <20220701044234.706229-1-kuba@kernel.org>
         <Yr8rC9jXtoFbUIQ+@electric-eye.fr.zoreil.com>
         <20220701144010.5ae54364@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-07-01 at 14:40 -0700, Jakub Kicinski wrote:
> 100%, I really wish something like that existed. I have a vague memory
> of Fedora or some other distro collecting HW data. Maybe it died because
> of privacy issues?

AFAICS that database still exists and is active:

https://linux-hardware.org/?view=search&vendor=neterion&d=All

It shows no usage at all for the relevant vendor.

On the flip side, it looks like the data points come mostly/exclusively
from desktop systems, not very relevant in this specific case.


/P

