Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5464FE9FA
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 23:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiDLVcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 17:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiDLVcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 17:32:24 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43524E3891
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 14:10:55 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id hu11so126207qvb.7
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 14:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iuRv7uDbkpVhklmScF34vPeD2ZOzfnANcG66j+oNSPE=;
        b=JU8KkxGPUIl6rMg9i5pSiF0wTKbehcPV51prsiwNYEssDUImoaU+LfUAQez65OxD4+
         8QVvMNOMeAzrJsYr2YN3JVYehYIxTxMu+gnxDjupdhs34eiwJ4iAWZjZ/AjJdkZrHMLv
         xZlUwie9zQebilmpqvE5qgdifpiMwLm5YpN6gBmhXm5lt/5yUlVakyfPoZgyKUByw8k/
         lY+5xAAFqbuYTHC1JfaxHOWxm5LSw/nMBShMjpM3OahVwT0jhxxJ475qbm1sGAGR3eqI
         ARQhH/x0A+nXeZVAVhe/j0dQxePBWXkjmIZipSY6HrYjsg2Yk4Ar22MlWkRy9UKTCFRi
         41fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iuRv7uDbkpVhklmScF34vPeD2ZOzfnANcG66j+oNSPE=;
        b=ggrxIwG0a9y7s98VuZODUEtagaFMRB1NABslv2YgXb84mECnRtHXsJrWrUDqGnZKVi
         7hhrZ6q4wZqLIDSnx4gnIZHHKtxd7ZZggFVuBGifokb9ixDEhiz7MJNX38nEPUGSD3f8
         rAzyjzl8lefzbVRPIfkDp0IEVrF4eFu+yvC/h96Im8j1YtC3p/8D1WmQLPCnDcKWruIc
         W7QqOjJSPASFyXhBzvPnT2I4y2c2Y9Zij5goH0a+MiemGfPbxAnBAR2Lj2mmohXlhsdz
         PxPzTqxntzPUaLJG5aq5EgybDGS5zKVOmBkw3IeeT/fFWm3odaonG2PfCuIJjJq6SisA
         wUrw==
X-Gm-Message-State: AOAM532yTyZs7Uj+vpqKdshXygGzooD+PZxnZoGj1qp8rBhF+GpLSSbK
        4T5IGxNoHoXMrYbl/r6wIIniKa+6LTKMojOT
X-Google-Smtp-Source: ABdhPJzF6EfStHyWq6lwPomr7nPI2CCnuI9sa4NDCtd82YZPKmYOzGxVizbwiVMbcERpO0dJTF+0ww==
X-Received: by 2002:a05:6a00:1c5c:b0:505:7469:134a with SMTP id s28-20020a056a001c5c00b005057469134amr6359655pfw.16.1649795175498;
        Tue, 12 Apr 2022 13:26:15 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p12-20020a63ab0c000000b00381f7577a5csm3609084pgf.17.2022.04.12.13.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:26:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCHSET 0/4] Add support for no-lock sockets
Date:   Tue, 12 Apr 2022 14:26:09 -0600
Message-Id: <20220412202613.234896-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

If we accept a connection directly, eg without installing a file
descriptor for it, or if we use IORING_OP_SOCKET in direct mode, then
we have a socket for recv/send that we can fully serialize access to.

With that in mind, we can feasibly skip locking on the socket for TCP
in that case. Some of the testing I've done has shown as much as 15%
of overhead in the lock_sock/release_sock part, with this change then
we see none.

Comments welcome!

-- 
Jens Axboe


