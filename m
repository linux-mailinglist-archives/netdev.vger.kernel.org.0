Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBF0683604
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjAaTFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjAaTFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:05:23 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B24A59261
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:05:20 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id e21-20020a9d5615000000b006884e5dce99so5722752oti.5
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OhtDzPFVguz2aWXytmmtt/443bFwgo0xn4xm4Oi7J1M=;
        b=QbA1DfR71of4AG0CA9XYTYWTq2rV98RTgNadwcbC0S9ojYDbYURfrB2z2rWezaovcj
         0ErHf0XY3jkigheC92mYVM3tzad3vrlFpwMp2VuKZPKYj39dhcwp6nvzsRtbXddncpT+
         i6iF+kngp4lBC5W5b8lNcY6fZ3GhHkqBZQDwfnoCUF8v/Zw6ATzoK9JyfROzVz7oJFtY
         noBxxKahTQSYpXxDeQ81bdApI9BzBgnJbA3B2sgsOwV6kWOXG/csynpN/9NSKQvIJRNk
         MEtN10nN0b1WCNfGb3pK7YOlqPSYVzmSCBiGq3E47wgyoi8Q3y0RGv6XD8SjPD31yDE+
         3VnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OhtDzPFVguz2aWXytmmtt/443bFwgo0xn4xm4Oi7J1M=;
        b=iypYzVqi/qWbQYOZotn4p3/EflONxoPiOMTFrOBjAQwSj9vxgzCAmOihD3eRVhsQCU
         xYViF7yH9Is00TLnSNIagjvifLbrEKlw0k6iXm2lEB7tPDDHn2gJpz8jM5TzHmFDn1UF
         0ddjnq/71rDUHdTONJkoGVvu73fU0i0nMmYEqHYH0yxDqEWJIBtoTsvDd16YfGrZpjuI
         uKV9lR5HsaU3CTiEbK2QN6bbV/I8XNCPQ4sODf0AkH2VaU2ps2aPEVg8pybxD1XZjypy
         nxPrcgb7Ez3CLOOGkpQaN2Nhsz8M7uB7j4Q0X0No3dPql+KJ4bILii/2tODTwcq070Mm
         bx0A==
X-Gm-Message-State: AO0yUKV/6GUfH54mxZGnavAU0joMCM4PNAO5bci6jy4W26AxLMo+Z8yg
        tfetTEGdf8hmNiJJrHny2Rfg/TsWL5JRogNx
X-Google-Smtp-Source: AK7set82aCXwhSFtoUlSeGrfzPBMfsOZ2Xshy5IyeKuj21LgDQ3zeVT7YX+gH7/vuCz3GiiBn9jxjw==
X-Received: by 2002:a9d:822:0:b0:68b:c9a2:4d79 with SMTP id 31-20020a9d0822000000b0068bc9a24d79mr6348211oty.33.1675191919676;
        Tue, 31 Jan 2023 11:05:19 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:1d86:b62f:e05b:126b])
        by smtp.gmail.com with ESMTPSA id i5-20020a9d6505000000b0068649039745sm6941450otl.6.2023.01.31.11.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 11:05:19 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v6 0/2] net/sched: transition act_pedit to rcu and percpu stats
Date:   Tue, 31 Jan 2023 16:05:10 -0300
Message-Id: <20230131190512.3805897-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The software pedit action didn't get the same love as some of the
other actions and it's still using spinlocks and shared stats.
Therefore, transition the action to rcu and percpu stats which
improves the action's performance.

We test this change with a very simple packet forwarding setup:

tc filter add dev ens2f0 ingress protocol ip matchall \
   action pedit ex munge eth src set b8:ce:f6:4b:68:35 pipe \
   action pedit ex munge eth dst set ac:1f:6b:e4:ff:93 pipe \
   action mirred egress redirect dev ens2f1
tc filter add dev ens2f1 ingress protocol ip matchall \
   action pedit ex munge eth src set b8:ce:f6:4b:68:34 pipe \
   action pedit ex munge eth dst set ac:1f:6b:e4:ff:92 pipe \
   action mirred egress redirect dev ens2f0

Using TRex with a http-like profile, in our setup with a 25G NIC
and a 26 cores Intel CPU, we observe the following in perf:
   before:
    11.59%  2.30%  [kernel]  [k] tcf_pedit_act
       2.55% tcf_pedit_act
             8.38% _raw_spin_lock
                       6.43% native_queued_spin_lock_slowpath
   after:
    1.46%  1.46%  [kernel]  [k] tcf_pedit_act

tdc results for pedit after the patch:
1..69
ok 1 319a - Add pedit action that mangles IP TTL
ok 2 7e67 - Replace pedit action with invalid goto chain
ok 3 377e - Add pedit action with RAW_OP offset u32
ok 4 a0ca - Add pedit action with RAW_OP offset u32 (INVALID)
ok 5 dd8a - Add pedit action with RAW_OP offset u16 u16
ok 6 53db - Add pedit action with RAW_OP offset u16 (INVALID)
ok 7 5c7e - Add pedit action with RAW_OP offset u8 add value
ok 8 2893 - Add pedit action with RAW_OP offset u8 quad
ok 9 3a07 - Add pedit action with RAW_OP offset u8-u16-u8
ok 10 ab0f - Add pedit action with RAW_OP offset u16-u8-u8
ok 11 9d12 - Add pedit action with RAW_OP offset u32 set u16 clear u8 invert
ok 12 ebfa - Add pedit action with RAW_OP offset overflow u32 (INVALID)
ok 13 f512 - Add pedit action with RAW_OP offset u16 at offmask shift set
ok 14 c2cb - Add pedit action with RAW_OP offset u32 retain value
ok 15 1762 - Add pedit action with RAW_OP offset u8 clear value
ok 16 bcee - Add pedit action with RAW_OP offset u8 retain value
ok 17 e89f - Add pedit action with RAW_OP offset u16 retain value
ok 18 c282 - Add pedit action with RAW_OP offset u32 clear value
ok 19 c422 - Add pedit action with RAW_OP offset u16 invert value
ok 20 d3d3 - Add pedit action with RAW_OP offset u32 invert value
ok 21 57e5 - Add pedit action with RAW_OP offset u8 preserve value
ok 22 99e0 - Add pedit action with RAW_OP offset u16 preserve value
ok 23 1892 - Add pedit action with RAW_OP offset u32 preserve value
ok 24 4b60 - Add pedit action with RAW_OP negative offset u16/u32 set value
ok 25 a5a7 - Add pedit action with LAYERED_OP eth set src
ok 26 86d4 - Add pedit action with LAYERED_OP eth set src & dst
ok 27 f8a9 - Add pedit action with LAYERED_OP eth set dst
ok 28 c715 - Add pedit action with LAYERED_OP eth set src (INVALID)
ok 29 8131 - Add pedit action with LAYERED_OP eth set dst (INVALID)
ok 30 ba22 - Add pedit action with LAYERED_OP eth type set/clear sequence
ok 31 dec4 - Add pedit action with LAYERED_OP eth set type (INVALID)
ok 32 ab06 - Add pedit action with LAYERED_OP eth add type
ok 33 918d - Add pedit action with LAYERED_OP eth invert src
ok 34 a8d4 - Add pedit action with LAYERED_OP eth invert dst
ok 35 ee13 - Add pedit action with LAYERED_OP eth invert type
ok 36 7588 - Add pedit action with LAYERED_OP ip set src
ok 37 0fa7 - Add pedit action with LAYERED_OP ip set dst
ok 38 5810 - Add pedit action with LAYERED_OP ip set src & dst
ok 39 1092 - Add pedit action with LAYERED_OP ip set ihl & dsfield
ok 40 02d8 - Add pedit action with LAYERED_OP ip set ttl & protocol
ok 41 3e2d - Add pedit action with LAYERED_OP ip set ttl (INVALID)
ok 42 31ae - Add pedit action with LAYERED_OP ip ttl clear/set
ok 43 486f - Add pedit action with LAYERED_OP ip set duplicate fields
ok 44 e790 - Add pedit action with LAYERED_OP ip set ce, df, mf, firstfrag, nofrag fields
ok 45 cc8a - Add pedit action with LAYERED_OP ip set tos
ok 46 7a17 - Add pedit action with LAYERED_OP ip set precedence
ok 47 c3b6 - Add pedit action with LAYERED_OP ip add tos
ok 48 43d3 - Add pedit action with LAYERED_OP ip add precedence
ok 49 438e - Add pedit action with LAYERED_OP ip clear tos
ok 50 6b1b - Add pedit action with LAYERED_OP ip clear precedence
ok 51 824a - Add pedit action with LAYERED_OP ip invert tos
ok 52 106f - Add pedit action with LAYERED_OP ip invert precedence
ok 53 6829 - Add pedit action with LAYERED_OP beyond ip set dport & sport
ok 54 afd8 - Add pedit action with LAYERED_OP beyond ip set icmp_type & icmp_code
ok 55 3143 - Add pedit action with LAYERED_OP beyond ip set dport (INVALID)
ok 56 815c - Add pedit action with LAYERED_OP ip6 set src
ok 57 4dae - Add pedit action with LAYERED_OP ip6 set dst
ok 58 fc1f - Add pedit action with LAYERED_OP ip6 set src & dst
ok 59 6d34 - Add pedit action with LAYERED_OP ip6 dst retain value (INVALID)
ok 60 94bb - Add pedit action with LAYERED_OP ip6 traffic_class
ok 61 6f5e - Add pedit action with LAYERED_OP ip6 flow_lbl
ok 62 6795 - Add pedit action with LAYERED_OP ip6 set payload_len, nexthdr, hoplimit
ok 63 1442 - Add pedit action with LAYERED_OP tcp set dport & sport
ok 64 b7ac - Add pedit action with LAYERED_OP tcp sport set (INVALID)
ok 65 cfcc - Add pedit action with LAYERED_OP tcp flags set
ok 66 3bc4 - Add pedit action with LAYERED_OP tcp set dport, sport & flags fields
ok 67 f1c8 - Add pedit action with LAYERED_OP udp set dport & sport
ok 68 d784 - Add pedit action with mixed RAW/LAYERED_OP #1
ok 69 70ca - Add pedit action with mixed RAW/LAYERED_OP #2

v5->v6:
- Address Simon's comments
- Bug fixes found by tdc

v4->v5:
- Address Simon's comments

v3->v4:
- Address Simon's comments

v2->v3:
- Add missing change in act idr create

v1->v2:
- Fix lock unbalance found by sparse


Pedro Tammela (2):
  net/sched: transition act_pedit to rcu and percpu stats
  net/sched: simplify tcf_pedit_act

 include/net/tc_act/tc_pedit.h |  81 ++++++++--
 net/sched/act_pedit.c         | 277 ++++++++++++++++++----------------
 2 files changed, 216 insertions(+), 142 deletions(-)

-- 
2.34.1

