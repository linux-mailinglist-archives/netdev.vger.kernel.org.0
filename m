Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450C164BCF
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfGJSAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:00:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4602 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727636AbfGJSAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:00:32 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6AHtj3e030113
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:00:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=5+41vTbm9ou4kBF0Kz/5PmJNWv3R0OjgUC8+rvhcfEw=;
 b=lAKGxV8weL6OUxwvLh7m+zf1gK7mt6riqq8paqpO9H3PcnU4Rs/3y4CPOAo3slRmkaoz
 tR5fMsBEpkQUUpE0hTa9PzKBPIEucsBcF5BC+O5JGCLzNRcXCuUqOVMqhe647Melc9qg
 1/UJyHgX3N2B3M3C/402dU48TDzYpUp0yZs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tndhq26m1-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:00:31 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 10 Jul 2019 11:00:29 -0700
Received: by devvm424.lla2.facebook.com (Postfix, from userid 134475)
        id CB28611FAA2FE; Wed, 10 Jul 2019 11:00:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Javier Honduvilla Coto <javierhonduco@fb.com>
Smtp-Origin-Hostname: devvm424.lla2.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <yhs@fb.com>, <kernel-team@fb.com>, <jonhaslam@fb.com>
Smtp-Origin-Cluster: lla2c09
Subject: [PATCH v6 bpf-next 0/3] bpf: add bpf_descendant_of helper
Date:   Wed, 10 Jul 2019 11:00:22 -0700
Message-ID: <20190710180025.94726-1-javierhonduco@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190410203631.1576576-1-javierhonduco@fb.com>
References: <20190410203631.1576576-1-javierhonduco@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907100201
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This patch adds the bpf_descendant_of helper which accepts a PID and
returns 1 if the PID of the process currently being executed is a
descendant of it or if it's itself. Returns 0 otherwise. The passed
PID should be the one as seen from the "global" pid namespace as the
processes' PIDs in the hierarchy are resolved using the context of said
initial namespace.

This is very useful in tracing programs when we want to filter by a
given PID and all the children it might spawn. The current workarounds
most people implement for this purpose have issues:

- Attaching to process spawning syscalls and dynamically add those PIDs
to some bpf map that would be used to filter is cumbersome and
potentially racy.
- Unrolling some loop to perform what this helper is doing consumes lots
of instructions. That and the impossibility to jump backwards makes it
really hard to be correct in really large process chains.


Let me know what do you think!

Thanks,

---
Changes in V6:
        - Small style fix
        - Clarify in the docs that we are resolving PIDs using the global,
initial PID namespace, and the provided *pid* argument should be global, too
        - Changed the way we assert on the helper return value

Changes in V5:
        - Addressed code review feedback
        - Renamed from progenyof => descendant_of as suggested by Jon Haslam
and Brendan Gregg

Changes in V4:
        - Rebased on latest bpf-next after merge window

Changes in V3:
        - Removed RCU read (un)locking as BPF programs alredy run in RCU locked
                context
        - progenyof(0) now returns 1, which, semantically makes more sense
        - Added new test case for PID 0 and changed sentinel value for errors
        - Rebase on latest bpf-next/master
        - Used my work email as somehow I accidentally used my personal one in v2

Changes in V2:
        - Adding missing docs in include/uapi/linux/bpf.h
-- 
2.17.1

