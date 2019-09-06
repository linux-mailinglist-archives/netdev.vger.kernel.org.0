Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692DDAC134
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 22:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390702AbfIFUC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 16:02:57 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40876 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731749AbfIFUC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 16:02:57 -0400
Received: by mail-wm1-f66.google.com with SMTP id t9so8348336wmi.5
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 13:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8JJMWwK+OuWMjxuh6BS4nZ5SDQNb4LT2xexI6IrhZpo=;
        b=FoP4jG42Z2Wl493g18AKeOWUG6UMGoAgVM4knbw2i1V/Tnlh4juYioN9y5NEbCQh7o
         OdpqCnTKrZvUcphgryQ+dxVSyHdsnfpUjzq8LvNoxT7xYSMrRNcOQmddl8Da6EyUGI3a
         +WJwMjH5HTp9d4XLtCruolX8Y55ns8O+/Vwjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8JJMWwK+OuWMjxuh6BS4nZ5SDQNb4LT2xexI6IrhZpo=;
        b=JkbsuijnughUg0DHlH/tgw4fRAyWDAxFiqsMn5yV6md7KZW/WUFx7FOsER1IfM3Ifh
         swCNASxkSLTryZFIYPAnneDzYYCFblNaNX+KcZGVbtV8DqxCRtIeY6tvx+p9MCoAmygk
         AqLLF03QBY2+joseKXSegsIJvcm5WBTae+y7xQo90Ebdl9o+VYHR6jZqPi3mgWETutIV
         b/Kok2rFYb4d5rtrOMXi78nUSFaUFzjdUtw5fiOX3jbA/y5PwHLD1IYvkxN17t2YArhr
         Adi0Y0+e2m65JRdb8meMiy2pr5GL60AmT4FYGMiNiIw0mjp/uyfnifnbQIPq7i3cy46b
         o/6g==
X-Gm-Message-State: APjAAAWc44Cph/1TqJBri7+kI3+TX4k7Bdjyt5e8NhwUgkhRQycrkO0H
        AElkGp+pu1J1TP3YZvjn3MOWNg==
X-Google-Smtp-Source: APXvYqyrYQTaqixTnWf4J/6zEVB6rzB8lccMoDSQdtY3HYGCzul9GTqFTuUi+R6mKP/iRkY+YXedGQ==
X-Received: by 2002:a7b:c3c6:: with SMTP id t6mr8686222wmj.5.1567800175048;
        Fri, 06 Sep 2019 13:02:55 -0700 (PDT)
Received: from pixies ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id f66sm9338132wmg.2.2019.09.06.13.02.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Sep 2019 13:02:54 -0700 (PDT)
Date:   Fri, 6 Sep 2019 23:02:51 +0300
From:   Shmulik Ladkani <shmulik@metanetworks.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, eyal@metanetworks.com,
        netdev <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH net] net: gso: Fix skb_segment splat when splitting
 gso_size mangled skb having linear-headed frag_list
Message-ID: <20190906230251.670f3a1b@pixies>
In-Reply-To: <CA+FuTSea6gTEFFsBfwSECQ8CSi3TFqi2mEPvMuaWNdHwQxwcLg@mail.gmail.com>
References: <20190905183633.8144-1-shmulik.ladkani@gmail.com>
        <CAF=yD-J9Ax9f7BsGBFAaG=QU6CPVw6sSzBkZJOHRW-m6o49oyw@mail.gmail.com>
        <20190906094744.345d9442@pixies>
        <CAF=yD-JB6TMQuyaxzLX8=9CZZF+Zk5EmniSkx_F81bVc87XqJw@mail.gmail.com>
        <20190906183707.3eaacd79@pixies>
        <CAKgT0Ufd40gmaW7eLu3sRHd=4CeY9WNmgRBUzNt5_+0tEKEMvA@mail.gmail.com>
        <CA+FuTSea6gTEFFsBfwSECQ8CSi3TFqi2mEPvMuaWNdHwQxwcLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>  
> 
> Reviewed-by: Willem de Bruijn <willemb@google.com>

Thank you Alexander and Willem.

Care to reply with you Reviewed-by tags on the v2 thread?

Best,
Shmulik
