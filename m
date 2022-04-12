Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5834FE9C2
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 23:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiDLVDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 17:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiDLVDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 17:03:04 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFC81A386
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:50:41 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id k14so18372715pga.0
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sKPPb7cPnakqop3K+/8izaNbWGNMof5p7iEV5Vm4YJE=;
        b=kYmUWMNxcC+KqIVlArIbkmQRM98LpBPSJeSyGdeB1Ye4c8cbBdTLCd2Ey0UrainBLw
         AB3suwXVPPu+i1o0/mq31q6eK90+IN81w8eTVeDwf5r6CHTc1na0EM68MnaXJnlTjJ64
         NJsylaDD8aX1wT/BhdKImGx2SHOdjNZMk5KFVIo26NRAztXCRmMkhsmnuOqENx5GxNQl
         Ck824E280Ye2NvWUgVeFW7uY+cWdE4q3nTFgAcfsDIiHNfLDuT29Z7ecYaceL/rxuKCl
         OIP+OYveG3hJyLMUwOOk4rYsH/CAcl2pYWt6BmhD9S+aH2TA9IwKlPjk+djvcCnXLnEN
         WP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sKPPb7cPnakqop3K+/8izaNbWGNMof5p7iEV5Vm4YJE=;
        b=HwV8TGwHAP76fa5V+RVZyuVdZiMM2KNMZT9vkOxRNbDaq+2KP8H7LQBQhKy7F/CZIC
         5MVK5RV47jLno6QrYBh+Cm6pFhAUwbQcah22tNllFBtH+ri/cju+YVqJ0ruTAwyYimF8
         1eq4BPOdc00XESHL2yNlgxjznAZvPNPF17mjm/iJykI39RvDILDw3P54oCx4AH8Nlt9R
         Q9QKfQguYes9vowxt6h6d+8oG19ABwy1DzB/TL/dh+SPwCVjXbcr7+MknfQ/yaSg92HR
         FJefU3CZ2aoBs5w4QPhpgoULgmHtKYN5EeTyz9E9hyEaHvHcdic34rQibFVmD231nQpI
         J+Qw==
X-Gm-Message-State: AOAM532M8DpXsRQ9eFty09G3fKhosP9wPcMcR/aH8V1jL1HEbEYU4lLq
        HUqkI2K+7QbRDMV7W1lj5hOYpECR4b5ujqfa
X-Google-Smtp-Source: ABdhPJwOBW9ho/sYBs6oClKSrSqGNqsvZpw/RwO8wihEqCCg8sjJSidsifugV6WfDh1w92B2RtIaoA==
X-Received: by 2002:a63:b0a:0:b0:39d:4d2d:a38c with SMTP id 10-20020a630b0a000000b0039d4d2da38cmr10379688pgl.394.1649794962965;
        Tue, 12 Apr 2022 13:22:42 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 2-20020a17090a0f0200b001cb6621403csm359541pjy.24.2022.04.12.13.22.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:22:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCHSET 0/2] Add io_uring socket(2) support
Date:   Tue, 12 Apr 2022 14:22:38 -0600
Message-Id: <20220412202240.234207-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The main motivator here is to allow creating a socket as a direct
descriptor, similarly to how we do it for the open/accept support.

-- 
Jens Axboe


