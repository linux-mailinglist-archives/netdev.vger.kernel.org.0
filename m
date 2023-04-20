Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337296E9D1D
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjDTUYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjDTUYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:24:04 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EBE6A66
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 13:23:08 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-50674656309so1245708a12.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 13:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682022186; x=1684614186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ynImc+a1Kv+N4/JC7O1Qm9MksfT/KCGr76fbcSp+Hmg=;
        b=mv9lo8SdfzyCZUjwSP9gfJecMaGDPA6PQBFSWcbphdhreuTgRRNlFeuQnMgfeaFrwh
         AZNUzo6Z9zlqijZ5/CdnR+SMnUE0bIlomyskPv1LMpJnnvMQaGwPZMVy8tKFeW1nVHUL
         lqBnaEPfp/VK4R2vgCBBcjUlsWWt+DG85CvCitHCQ4Lhu9/qv7Mfmo/9hqwH+YNsIIdZ
         HPC3PAaD1bcGQ4Lur7pBbsx6Q2/OPHM16MZ0mTT93X/jfNwMcU4L+6NQIEV/EzrcyEAl
         lWOtLSXozsDr86SSfU4bj4F0ShUP9Vfa4D6YqT13z1nKbhccuUnSpAT3MLRozehpZ10h
         5vHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682022186; x=1684614186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynImc+a1Kv+N4/JC7O1Qm9MksfT/KCGr76fbcSp+Hmg=;
        b=IqzX11MuBGZW+jkVQggYbfxrClJpiMMsZ0UnK3q8kiof0LlIa8Bg17COxLOmVA/4JB
         kwGvPn/Y4lF0URiQnTOkcM/zZSmHcir4XMoBLKHFaYsp7CVPkw8sE6fk0kHw7271VCqZ
         khRVHTUp5uPsd2NCq7/jeLU3f2GTS/Jc56BUTID1oP+puqdOKMIvJWwNNxTFjwbW6fLP
         Kxfwp4hmZnb5IKCBNfFmqgJ4WmLSz+OpDYpg0u+eqjRx8R/uuvedq2Wze5CXdkaNE9sz
         te/G8JgaLG0xaOkCB/5zAbbQ5jh7FvIW9IMu5kwZK9trxvZ9PzXqo2YQWeR0FwG4ty0i
         MNKg==
X-Gm-Message-State: AAQBX9dYdk+4sWEfyRUdpPoTKlV2OY+uPt8rVHIhzFnKiIVper7w6fdz
        Myg7y3jvC06lKc6BH9p+gIs=
X-Google-Smtp-Source: AKy350ZGFVpFa6Z8Y6/b94NiLqK6YhhY7xDpzTzGdPCGIJmW7CtUzgH0rm8rX1sxqxXZVzK0luyDxA==
X-Received: by 2002:a05:6402:406:b0:504:9ae7:f73b with SMTP id q6-20020a056402040600b005049ae7f73bmr3058695edv.2.1682022185862;
        Thu, 20 Apr 2023 13:23:05 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id l7-20020a056402124700b00504937654f8sm1097061edw.21.2023.04.20.13.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 13:23:05 -0700 (PDT)
Date:   Thu, 20 Apr 2023 23:23:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: Always assign be16 value to vlan_proto
Message-ID: <20230420202303.iecl2vnkbdm2qfs7@skbuf>
References: <20230420-bonding-be-vlan-proto-v1-1-754399f51d01@kernel.org>
 <9836.1682020053@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9836.1682020053@famine>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 12:47:33PM -0700, Jay Vosburgh wrote:
> Simon Horman <horms@kernel.org> wrote:
> 
> >The type of the vlan_proto field is __be16.
> >And most users of the field use it as such.
> >
> >In the case of setting or testing the field for the
> >special VLAN_N_VID value, host byte order is used.
> >Which seems incorrect.
> >
> >Address this issue by converting VLAN_N_VID to __be16.
> >
> >I don't believe this is a bug because VLAN_N_VID in
> >both little-endian (and big-endian) byte order does
> >not conflict with any valid values (0 through VLAN_N_VID - 1)
> >in big-endian byte order.
> 
> 	Is that true for all cases, or am I just confused?  Doesn't VLAN
> ID 16 match VLAN_N_VID (which is 4096) if byte swapped?
> 
> 	I.e., on a little endian host, VLAN_N_VID is 0x1000 natively,
> and network byte order (big endian) of VLAN ID 16 is also 0x1000.
> 
> 	Either way, I think the change is fine; VLAN_N_VID is being used
> as a sentinel value here, so the only real requirement is that it not
> match an actual VLAN ID in network byte order.
> 
> 	-J

In a strange twist of events, VLAN_N_VID is assigned as a sentinel value
to a variable which usually holds the output of vlan_dev_vlan_proto(),
or i.o.w. values like htons(ETH_P_8021Q), htons(ETH_P_8021AD). It is
certainly a confusion of types to assign VLAN_N_VID to it, but at least
it's not a valid VLAN protocol.

To answer your question, tags->vlan_proto is never compared against a
VLAN ID.
