Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC23276772
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 05:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIXDq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 23:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgIXDq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 23:46:29 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E73AC0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 20:46:29 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id m25so441696oou.0
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 20:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=/D3TUiX3fVcm7eeRMzDMLamuFR1Z+NNvRtWWlZaFt4U=;
        b=oDBjTppI1QmFoHuFvHz0OR0YoVjJI5dSZ05Q8SuE0N7EnAs96S8wsBz/PKPdfDek4D
         J4DtkIefD+sRPvvg17DX0KpKWdxwSAyjQdJUXv4xO5czQsdwOK1tlym7hUApVLqOatvz
         dcRgybjvmPmRvsG52LkDncOCi4JeLlPMQDTRZl0PhtfRDdNqAA1hsgLYp84i3q5NElEV
         mlxUhTioACA8za0VurwwABf2LEJEvO+c/UXiohWGM39ZGDw6n3cgCv34yL8NwuUcKMzj
         TU6eTY2L5Dz9A0SWVV7LVCecmWnRdxhmfvflWfMzOjFSH568uccTFq7aXcvuEDn2REzZ
         ctYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=/D3TUiX3fVcm7eeRMzDMLamuFR1Z+NNvRtWWlZaFt4U=;
        b=G21HbXwqyHKW4TOhjGr/jWN2U7bSp6qCD1I821lFIPlAB9CLyms7R7lUo30tsrw5F5
         viYGzNFHw5soMyvmUo+tdW+a4L/gniphpD89K88I0CILfFQhFrZlOjQbAv2jsPUHZWrp
         GRg4eXddPZ3S+AXbiIKQURbE3vDVxJtqtD5B+ODv9rubY/DdDw0rjeG3MHJBXZYQ6KjP
         NLTVUCjgCrRERoiZt64sSjlWanb//zx0UJANJLTBRt6/57ly85NOZMLUUKV4UBcynnWi
         GDS3nxw1FVnBqsIcTD1k3n+hJtvfIyCY2uF6ZQspxCUvrfVRHrEErvv6+5VPKeMsl+vr
         I1nQ==
X-Gm-Message-State: AOAM531bhX1kIj21lE0d70fEtTFJYbK5fDTbrNWI8OouMe9+wHvbfebc
        qMT0Hhx8lUuQvt/Hr3rVHYW3fElintY=
X-Google-Smtp-Source: ABdhPJxW1jx0WcAnIh0KzpPSqGwOMmJx4ufA92+MJlKZ3f5g0zHOUluPbyISDGlon/P8Jo9TeDtftw==
X-Received: by 2002:a4a:7055:: with SMTP id b21mr1961406oof.26.1600919188221;
        Wed, 23 Sep 2020 20:46:28 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m8sm529908otn.66.2020.09.23.20.46.27
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Sep 2020 20:46:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 23 Sep 2020 20:46:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     netdev@vger.kernel.org
Subject: skb_under_panic with corrupt (?) head/data pointers
Message-ID: <20200924034626.GA226842@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

we are seeing situations where skb_under_panic is reported with bad
data pointers. A recent example is [1], but we have seen more of the same.
Some random examples:

skb_under_panic: text:0000000039ea4f04 len:272 put:48
	head:00000000bdd3f564 data:00000000f70d12b8 tail:0x102 end:0x2c0 dev:wlan0
skb_under_panic: text:0000000063ae0b92 len:822 put:48
	head:000000004ae66619 data:0000000082f8ca57 tail:0x328 end:0x6c0 dev:wlan0
skb_under_panic: text:0000000056205094 len:272 put:48
	head:000000003aad43d6 data:00000000e8cd088c tail:0x102 end:0x2c0 dev:wlan0
skb_under_panic: text:00000000413c3f8c len:368 put:48
	head:00000000ddd1266f data:00000000f13009ae tail:0x162 end:0x2c0 dev:wlan0
skb_under_panic: text:00000000917c4645 len:520 put:48
	head:000000007108f7f3 data:000000003d260246 tail:0x1fa end:0x6c0 dev:wlan0

This specific condition happens rarely; we do see lots of 'normal' skb_under_panic
crashes (with valid head and data pointers) in the same driver.

I would assume that the skbs are corrupted, but then I noticed a similar pattern
in some kernel commit logs.

commit 7901cd97963d:
    skb_under_panic: text:00000000ca46ad8a len:80 put:20
	head:00000000cd28494e data:000000009366fd6b tail:0x3c end:0xec0 dev:veth0
commit 7901cd97963d:
    skb_under_panic: text:000000001d390b3a len:31 put:24
	head:00000000d8ed776f data:000000008150e823 tail:0x7 end:0xc0 dev:gre0

Is there some situation where skb->head and possibly skb->data may not be
initialized correctly ?

Thanks,
Guenter

---
[1] https://www.spinics.net/lists/linux-wireless/msg200403.html
