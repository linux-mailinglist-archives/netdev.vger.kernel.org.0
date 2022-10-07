Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4ECF5F7BD8
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 18:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJGQ4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 12:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiJGQ4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 12:56:45 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD1760496
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 09:56:44 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id p186so4072582iof.5
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 09:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Oa2/HFjWMNLTULhMDOgWelTSl3U37miUk1sRVI0ZK3k=;
        b=OFQ/5vP1th2kjaaw6ddWTQE7n5DauO+8SJsVh6SdFE0aaXbGUiU/rkh4lVFrOnFUzh
         QnQdhEzCjlipx1Pj8rF/9MwQzu/WUXL1SEqH9NjMKTBDXC7pN33fWuGz5FDEI7N3kB5b
         igwDi2KNXatGW1zFZq57/I3A+0kEzHfrgNlSovTcuNgQEeb77EVeHDuY7U81+//sKGjD
         LbA+uucsz19tANsodRtEAJ6YFsmrcbzEIgBuawinReDZiUpCLv1CRmYAJnG9EvJfKnF9
         e4LU0b47RVswmxtLHA/WpeSHfwmY6yq35K0CFjtPkhkwC/QvWk71U078z5unaC2Rfd2b
         nB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oa2/HFjWMNLTULhMDOgWelTSl3U37miUk1sRVI0ZK3k=;
        b=LAXfiN6PADoigr7jhGY7S4Xwoi8SucHRpfBuhmnhLamKQEv0skpYF+GFVz4K5yOgAM
         CYaSK8pcvKRrxn/G4J+6PcA1Ve98P7odda6A9pwigMHIJAMWcqS3t2VYPQLHjrgiexpN
         it2JcSakuX33sL4XilDOLjuvYkwOUWQcSTjhY/1XcaOCZWuX/rZaMXTcyMq+S8dEc4wY
         ukFyD1tABI73MkgntyhxhcctLNwlTAAYj70dkIY9+ytoBFt2SZeba68y/1S4x5BBZOSy
         72+FW5vw/DIDB0jPDSkR4dxxIlwJiCK+tHnOuqV5xoIHriBNgjHEj4CzOmpouuJrq9lf
         AvYA==
X-Gm-Message-State: ACrzQf1fWpE5+CCiUqDRqby2PmPa4+l0+1jeeZHK0+jth/Y3/h6blG7J
        FhG2CIiNZDFR/utgzfsTABOfB3DCuL87EQ==
X-Google-Smtp-Source: AMsMyM7yb7LTOtDDLFfd/VGRTTGnFBXK2L4Z4nD958CXdFm3yIK+PeQmNIfXHqAdik4KBPM5IEZgaw==
X-Received: by 2002:a6b:c850:0:b0:6bb:b0e0:96b8 with SMTP id y77-20020a6bc850000000b006bbb0e096b8mr1308336iof.136.1665161802287;
        Fri, 07 Oct 2022 09:56:42 -0700 (PDT)
Received: from m1max.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a6-20020a056e020e0600b002eb5eb4f8f9sm1055584ilk.77.2022.10.07.09.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 09:56:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCHSET RFC 0/4] Add support for epoll min_wait
Date:   Fri,  7 Oct 2022 10:56:33 -0600
Message-Id: <20221007165637.22374-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This adds support for EPOLL_CTL_MIN_WAIT, which allows setting a minimum
time that epoll_wait() should wait for events on a given epoll context.
Some justification and numbers are in patch 4, patches 1-3 are really
just prep patches.

Sending this as an RFC to hash out the API, basically. This is
obviously a per-context type of operation in this patchset, which isn't
necessarily ideal for any use case. Questions to be debated:

1) Would we want this to be available through epoll_wait() directly?
   That would allow this to be done on a per-epoll_wait() basis, rather
   than be tied to the specific context.

2) If the answer to #1 is yes, would we still want EPOLL_CTL_MIN_WAIT?

I think there are pros and cons to both, and perhaps the answer to both
is "yes". There are some benefits to doing this at epoll setup time,
for example - it nicely isolates it to that part rather than needing
to be done dynamically everytime epoll_wait() is called. This also
helps the application code, as it can turn off any busy'ness tracking
based on if the setup accepted EPOLL_CTL_MIN_WAIT or not.

Anyway, tossing this out there as it yielded quite good results in
some initial testing, we're running more of it.

-- 
Jens Axboe


