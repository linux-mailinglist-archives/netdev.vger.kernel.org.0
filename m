Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2FE13509B
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgAIAox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 19:44:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30886 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726654AbgAIAox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 19:44:53 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0090dZpF022513
        for <netdev@vger.kernel.org>; Wed, 8 Jan 2020 16:44:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=V7/umriol0bL43X+cEmp7XeQfwdSmHpl4BxkKhK1phU=;
 b=qQhak0OgLcAFps4L4vwVgdNpHDu7+fmfmUtUCkfLFoaiJKQNxIhpLaNSLvjM01fBDhkC
 vWvXpwXIg88h994h6zUyXj9m4yymzciLWQM7I98/9y0wBwmLhD+yD1H6NkG08rPq8I6h
 LMZ08pr+FqvJLqQnXExjRRVEkmo2Ate1Fmg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2xdh772vny-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 16:44:38 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 8 Jan 2020 16:44:26 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 6FB9D2942449; Wed,  8 Jan 2020 16:44:24 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 01/11] bpf: Save PTR_TO_BTF_ID register state when spilling to stack
Date:   Wed, 8 Jan 2020 16:44:24 -0800
Message-ID: <20200109004424.3894196-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200109003453.3854769-1-kafai@fb.com>
References: <20200109003453.3854769-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_07:2020-01-08,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=13 bulkscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 spamscore=0 clxscore=1015
 mlxlogscore=668 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001090004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes the verifier save the PTR_TO_BTF_ID register state when
spilling to the stack.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6f63ae7a370c..d433d70022fd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1916,6 +1916,7 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
 	case PTR_TO_TCP_SOCK:
 	case PTR_TO_TCP_SOCK_OR_NULL:
 	case PTR_TO_XDP_SOCK:
+	case PTR_TO_BTF_ID:
 		return true;
 	default:
 		return false;
-- 
2.17.1

