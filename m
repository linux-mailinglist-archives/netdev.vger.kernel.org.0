Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1B29A2C0C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 03:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfH3BIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 21:08:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39144 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfH3BIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 21:08:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so5232213wra.6
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 18:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mCTyP2ecJqAv2Yq01Krjmjm1U2TKSr7CLKv4dgIRm7Y=;
        b=pYvxygvvVks7kISBo1PqIQsGMde0FRTxx/CMdw5emXMByhB7ta8Ru70uw0RAtz9JPK
         sn65XAIlmdolJ5huVl2VzdrzE0El5bq085R2wBTi7lq0wYRRXrQnWJgL2Iq5w0KDU8Hk
         xd59JiP3UQmdI/HRTHRwKerPIO3FJLPB3gsxSwPnk3bILN10nwqWMKfJ/rOhdp8gO58i
         TH4HrytlKOJnImvazssFRrJqXVeoZ+B8ELYmMCBFpASnz9aIWGaF+eLIjLKnakiv2piT
         5H3tcaIS0S2XiFc5vxeCoZ38pme0M/oui4AljpITb2akXDFaN6D3+4PEy0TgpQcC0X2M
         Vd4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mCTyP2ecJqAv2Yq01Krjmjm1U2TKSr7CLKv4dgIRm7Y=;
        b=jcNyeIMIZt5SaM2FOQfrdhcq7V2AE1py/zB9AEjM5mXoUzQLykA1ni2f3JA6J9XMH1
         FJz7BBqwMCMzsAxcLkKz22i61LYezGV6KqY8ivACLve8bLid6VEdDRHQmxftDmj+i42E
         oUt5+WZ5NosqToxVhWvqsCj2XxEFTRXkANPzyMb1+YtLpRGuyTSyqhAAkkPy/EGM11hb
         WD6ROchGlxa529YEjB/VGiu81c74mm6zHhlpSQLG7eqsLVMWNszlJS5hzzjqJvTVgJNB
         90ggzL1JaGfpIMXowwwDzFnT86OxTwfWEso5FWsVlok8nftw8jjAGLgZOyGypBXyW5Kt
         udiA==
X-Gm-Message-State: APjAAAXI422y7OU3q0jDiL3ofrxgAt7rmNan7IIsFxLTIfcB+nQGbiSP
        3+btszE1yZEXLXdSxWoggPA8Dp7RA2Y=
X-Google-Smtp-Source: APXvYqyMvpJaCcqYGiFXZFez/u7i2LgPI0gREXH+AgjW7gY/P52wieZmNWbZTPFYoeUD+/tAj5f+Wg==
X-Received: by 2002:a05:6000:12c5:: with SMTP id l5mr14830052wrx.122.1567127292071;
        Thu, 29 Aug 2019 18:08:12 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id f13sm2813317wrq.3.2019.08.29.18.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 18:08:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        leandro.maciel.dorileo@intel.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 0/3] Fix issues in tc-taprio and tc-cbs
Date:   Fri, 30 Aug 2019 04:07:20 +0300
Message-Id: <20190830010723.32096-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes one panic and one WARN_ON found in the tc-taprio
qdisc, while trying to apply it:

- On an interface which is not multi-queue
- On an interface which has no carrier

The tc-cbs was also visually found to suffer of the same issue as
tc-taprio, and the fix was only compile-tested in that case.

Vladimir Oltean (3):
  taprio: Fix kernel panic in taprio_destroy
  taprio: Set default link speed to 10 Mbps in taprio_set_picos_per_byte
  net/sched: cbs: Set default link speed to 10 Mbps in cbs_set_port_rate

 net/sched/sch_cbs.c    | 19 +++++++++++--------
 net/sched/sch_taprio.c | 31 +++++++++++++++++--------------
 2 files changed, 28 insertions(+), 22 deletions(-)

-- 
2.17.1

