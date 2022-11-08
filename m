Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C70621EF2
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiKHWQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiKHWQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:16:55 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056D261B95;
        Tue,  8 Nov 2022 14:16:54 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso151094pjc.5;
        Tue, 08 Nov 2022 14:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kg0VFpmVctbaS2R2BvaZL5i+SVLF+xudlOVUQRPBDsU=;
        b=B8b8BpCpyEY4UcshDqcmlYIjA2cgmYqYztczau+2cdIbIudTHEAN5v4NyY5LTZf6KI
         3RyNyrJZ+PnsLGfQxKzZoCtEE1qnAGJcbLGKYMhmPykwpVAWMu1ZT5qqElOj7U5+Tt2K
         pGhpqhjfgPfh2GPZ7PKgU6PywzoxsGTXPjxQcT9Wf5bUpg5TOAZiPYN9kYztMQDObs6U
         doq/GChlyuRJTIqt7vf2KJdr6A1Z1J29FkDEzCnRvw5kaDbGx0CJfUaq2GPmMfLjSyKr
         r0hW4deAfXInLb5eJaufyRrOszYt9eP+A+x+Hbnwe4f0NciqYwDLRlZzLN6GZXCwgO6H
         lv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kg0VFpmVctbaS2R2BvaZL5i+SVLF+xudlOVUQRPBDsU=;
        b=FR1MWap5NTfCBvG2J5OpxRx3r5ZeK8yP/BViU8sJqvQgsLD/eVKw7OfaAUzf7ckG4h
         yCNYyQswjq1rvTCO2DSGjjkaaqY7gBOfs9Jt1Kmdx1QtqmDRiu2eUabt6EV2iq7BC+uq
         7tpqVbNjMtX5A7HSx9uysAkuWzF+5hF/+trA9UlK2ZziE2Bmrw2AyHqbmBC3kxHpBOEm
         OOIiiqTKoTTPQ2lQnRrorgG+a54LfoOUyI7Fdu9U6AFQARIjkyYA8PkXZZGPbM3Gz4lq
         dc6jmi6rklQ0meQGTMBxohXtDHa0oYfncCTP/ZCGW5qo+myp4gKLO/OFRmNxIp73Nkuw
         3/Lg==
X-Gm-Message-State: ACrzQf2qcgs1squ4FzSqiRoQwgypSnlCbUviS97u6QnsBJCkEEA328g/
        Q9mWhbXJuFcSZ7A/q1KcqEQ=
X-Google-Smtp-Source: AMsMyM5h/arPkkA1e1MpeVG8zTjOlPNEI+u9q1kRVYHlKyrIUXDG2EZKJCXcjZpRUNpRft3mv9f7OQ==
X-Received: by 2002:a17:902:be06:b0:187:4466:aaba with SMTP id r6-20020a170902be0600b001874466aabamr37848881pls.0.1667945813482;
        Tue, 08 Nov 2022 14:16:53 -0800 (PST)
Received: from john.lan ([98.97.44.106])
        by smtp.gmail.com with ESMTPSA id p3-20020a622903000000b005636326fdbfsm6848366pfp.78.2022.11.08.14.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 14:16:52 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     daniel@iogearbox.net, kuba@kernel.org, davem@davemloft.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [0/1 bpf-next] fix panic bringing up veth with xdp progs
Date:   Tue,  8 Nov 2022 14:16:49 -0800
Message-Id: <20221108221650.808950-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not sure if folks want to take this through BPF tree or networking tree.
I took a quick look and didn't see any pending fixes so seems no one
has noticed the panic yet. It reproducible and easy to repro.

I put bpf in the title thinking it woudl be great to run through the
BPF selftests given its XDP triggering the panic.

Sorry maintainers resent with CC'ing actual lists. Had a scripting
issue. Also dropped henqqi has they are bouncing.

Thanks!

John Fastabend (1):
  bpf: veth driver panics when xdp prog attached before veth_open

 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.33.0

