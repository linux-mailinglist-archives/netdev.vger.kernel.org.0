Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9E31183ED8
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 02:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgCMBuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 21:50:17 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33717 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgCMBuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 21:50:16 -0400
Received: by mail-pf1-f195.google.com with SMTP id n7so4237062pfn.0;
        Thu, 12 Mar 2020 18:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=on6YR81tppI3WeAL+gwJSsYOHfdaX/jkaYhx4fntqxc=;
        b=prVgVe2zjLvgq0rpJg/H5NvmtXlt7fJEOBLfiApHdHpb/1SxxaUM1HOl6Gw2aqyDiI
         iVCFg/jXAWW+Mppm28VXYp1b/bVs6yItpXdH6NR4O3pcIKiDbIqCY74iRGxsueEcfaHS
         qyKaW55O/XWeGIv7IP0zXJk7DVVxxDxtQmfheJx24BlkEF+gpPYO2penw1U0xgV29ydj
         BkqK95ovK1nEiocno0URah0JmNxPVYzTLcaB5fEY4TxVB8p/ZdeIlogm5Khqu4tRdOYo
         PgwgTumnAqgwI4bthuR6IgbQb4mKZOfSVUp2rrsWqv5jbyfWkgXArVE2JARf0hCSGTUv
         g+PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=on6YR81tppI3WeAL+gwJSsYOHfdaX/jkaYhx4fntqxc=;
        b=bd7ivd0apOu1ZTKUj8Hi5zkAaa1oPh4sJues9TbD8jkFpGILNxpe1ZCPRrA1si/CDM
         0Aow2EKOi/8ah4b3wA0HEHSOQgFaUVk5xxDQbxUTA2DiJaUamM1NrxN1Tml04fp86mZV
         kGpxyQR/LnyLbyIJjElM/oY0xCZ3YwfNFg6MDLrAcheYo0taEKV3AuietUAXdKZ3f9La
         XipBbH7QKJYZPcmY2CddCrrcc0s29stiOw7ZDCm883zg7yVw5IlsafiyDQrdQYy6HVUQ
         eKPwQzGejCULaiuNEtX/KNbYCM3aiumRhJhEHTBjUS/M2EYAf3FcNJMLSpmId5yzbB1l
         A5hQ==
X-Gm-Message-State: ANhLgQ3n0Rro0OtVtfl5npFPdY4hwi6olFzhN2TMgLSkVV10DU914Er1
        KJ37Ifl7eO5KYQzLgxHuBce7a4c3
X-Google-Smtp-Source: ADFU+vuQiWqJlKCB4qTEShyW5NHfTFkTQV3NVAXp5QUpfZSpj+DAy1b/FI5gjWJQtSxsJSNQ5j/UHw==
X-Received: by 2002:a63:2cce:: with SMTP id s197mr11007470pgs.184.1584064215566;
        Thu, 12 Mar 2020 18:50:15 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:df27])
        by smtp.gmail.com with ESMTPSA id j12sm39654399pga.78.2020.03.12.18.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 18:50:14 -0700 (PDT)
Date:   Thu, 12 Mar 2020 18:50:12 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next] bpf: abstract away entire bpf_link clean up
 procedure
Message-ID: <20200313015012.nejdagphpe44k27i@ast-mbp>
References: <20200313002128.2028680-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313002128.2028680-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 05:21:28PM -0700, Andrii Nakryiko wrote:
> Instead of requiring users to do three steps for cleaning up bpf_link, its
> anon_inode file, and unused fd, abstract that away into bpf_link_cleanup()
> helper. bpf_link_defunct() is removed, as it shouldn't be needed as an
> individual operation anymore.
> 
> v1->v2:
> - keep bpf_link_cleanup() static for now (Daniel).
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied.

But noticed that the test is now sporadically failing:
./test_progs -n 24
test_link_pinning:PASS:skel_open 0 nsec
test_link_pinning_subtest:PASS:link_attach 0 nsec
test_link_pinning_subtest:PASS:res_check1 0 nsec
test_link_pinning_subtest:PASS:link_pin 0 nsec
test_link_pinning_subtest:PASS:pin_path1 0 nsec
test_link_pinning_subtest:PASS:stat_link 0 nsec
test_link_pinning_subtest:PASS:res_check2 0 nsec
test_link_pinning_subtest:PASS:res_check3 0 nsec
test_link_pinning_subtest:PASS:link_open 0 nsec
test_link_pinning_subtest:PASS:pin_path2 0 nsec
test_link_pinning_subtest:PASS:link_unpin 0 nsec
test_link_pinning_subtest:PASS:res_check4 0 nsec
test_link_pinning_subtest:FAIL:link_attached got to iteration #10000
#24/1 pin_raw_tp:FAIL
test_link_pinning_subtest:PASS:link_attach 0 nsec
test_link_pinning_subtest:PASS:res_check1 0 nsec
test_link_pinning_subtest:PASS:link_pin 0 nsec
test_link_pinning_subtest:PASS:pin_path1 0 nsec
test_link_pinning_subtest:PASS:stat_link 0 nsec
test_link_pinning_subtest:PASS:res_check2 0 nsec
test_link_pinning_subtest:PASS:res_check3 0 nsec
test_link_pinning_subtest:PASS:link_open 0 nsec
test_link_pinning_subtest:PASS:pin_path2 0 nsec
test_link_pinning_subtest:PASS:link_unpin 0 nsec
test_link_pinning_subtest:PASS:res_check4 0 nsec
test_link_pinning_subtest:FAIL:link_attached got to iteration #10000
#24/2 pin_tp_btf:FAIL
#24 link_pinning:FAIL
Summary: 0/0 PASSED, 0 SKIPPED, 3 FAILED

it's failing more often than passing, actually.

The #64 tcp_rtt also started to fail sporadically.
But I wonder whether it's leftover from 24. shrug.
