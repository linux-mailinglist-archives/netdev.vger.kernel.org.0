Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997753EE93E
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbhHQJOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbhHQJOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:14:03 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF38C061764;
        Tue, 17 Aug 2021 02:13:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so5410934pjb.0;
        Tue, 17 Aug 2021 02:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=7hFl+lvECuO7AZrUUDXWnuHbyid4dTyMDCfojPCaIqo=;
        b=HbAwPBVxqYVBNSIWFUVtrs0IMzcWdevND/Bs5whRGJRR3xcQUwPv8ASMjr9F5vBtKs
         UVF269FKV2jKsog2X0w9D46iqKy29PT4sdgDVUsTau49IddPeAcuLDRHDr15uPf0t9EL
         6Xvhh/U2NQStRmd4VYneToiEWY19ADO/i/1Gyn3I/LbgirDY3AJaKScapVq6Ie5xiryz
         BZavh8YDNJS6OyyEoYOgsNQDFW3oxspgCbVOOogXCRPkZPmBzRSnsYl0GiIrnPiJN9Tu
         WTlJ9RvtCbaY66mhSa1YYXnbg3LV4TD0QP+jx9n8QIS8tC/G0sGS5mZluZDg3+GVT7gs
         RLhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=7hFl+lvECuO7AZrUUDXWnuHbyid4dTyMDCfojPCaIqo=;
        b=qwpS5QXVHgoP3lCk6fO63if/PU38dScytagqJyjmnXsllmyyIaXWfN9s4sCHoX5U58
         wA9bnnZbLCcqk5r1GgfVrOobQ2A6M3mbq8+LV3ZPlzNrkWjwfuNryj+8GPq4M4bucHy5
         Yf1l5QXfFF7D9OjEEDDyEiwfdDldV9+Yv7DoS6qx4n9WH6wE3g4MtszZY4pEWVp83E3T
         ujFhn7z/JBRwmlYtUUhQX5YDj1NZnTbNgKmRKRIRYYkLeD+BzQzB5003GX9cMX/ENc4r
         MolVPANsLnJsci6Da5DV5lXQRQTY+FYuyK0V3bJpnAOX3IgUHD9OEDepDDTMUc9cCope
         PUbQ==
X-Gm-Message-State: AOAM533gaGRhDsXwRQ3f0bhgEWWeI1DbLJZ5tFB26kqn18Es8mB0BJ0x
        wFRBSFNQXFVfCCWDjb2wohA=
X-Google-Smtp-Source: ABdhPJxHI1dM8zK2COH1XPjzlYAwHAHgWtNEqcIr/Bsks62txFI2scVFQWlvqty7C3PvXy8uJLiEhg==
X-Received: by 2002:a17:90a:384b:: with SMTP id l11mr2699892pjf.208.1629191609882;
        Tue, 17 Aug 2021 02:13:29 -0700 (PDT)
Received: from [10.211.55.3] ([202.78.233.119])
        by smtp.gmail.com with ESMTPSA id n22sm1853892pff.57.2021.08.17.02.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:13:28 -0700 (PDT)
From:   Saubhik Mukherjee <saubhik.mukherjee@gmail.com>
To:     isdn@linux-pingi.de, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, dsterba@suse.com, jcmvbkbc@gmail.com,
        johannes@sipsolutions.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrianov@ispras.ru
Subject: [question] potential race between capinc_tty_init & capi_release
Message-ID: <af56f61a-6343-85fd-3efc-b3a2890246ac@gmail.com>
Date:   Tue, 17 Aug 2021 14:43:22 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In drivers/isdn/capi/capi.c, based on the output of a static analysis 
tool, we found the possibility of the following race condition:

In capi_init, register_chrdev registers file operations callbacks, 
capi_fops. Then capinc_tty_init is executed.

Simultaneously the following chain of calls can occur (after a 
successful capi_open call).

capi_release -> capincci_free -> capincci_free_minor -> capiminor_free 
-> tty_unregister_device

tty_unregister_device reads capinc_tty_driver, which might not have been 
initialized at this point. So, we have a race between capi_release and 
capinc_tty_init.

If this is a possible race scenario, maybe moving register_chrdev after 
capinc_tty_init could fix it. But I am not sure if this will break 
something else. Please let me know if this is a potential race and can 
be fixed as mentioned.

Since this is based on a static analysis tool, this is not tested.
