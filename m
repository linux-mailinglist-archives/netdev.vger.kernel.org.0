Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB16826EC0
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388010AbfEVTv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:51:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43360 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732095AbfEVTvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:51:23 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MJlLhW028296
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 12:51:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=zadAt1aXztVRcYLP4/pIlA8/YTNS3mRm3Oc6W03zeiU=;
 b=golMVzduOoKGqg0/wfEKOVO3ls/4T7NKq9QTlGDzdJMw9lCIixTpLlt+Cm2d4i0IVytH
 HUHPleMAvsHrGuT9KRq5vkRu/CRqbIvU31HfcPX++xuw0B4MaP3K+Cyj8jLOtAUwEdvo
 hWXCiBP1bkjxOXmPzOGTrVfSaKa3ScyqqWY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sn9bgryss-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 12:51:22 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 22 May 2019 12:51:21 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 8E488862334; Wed, 22 May 2019 12:51:19 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 12/12] bpftool: update bash-completion w/ new c option for btf dump
Date:   Wed, 22 May 2019 12:50:53 -0700
Message-ID: <20190522195053.4017624-13-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190522195053.4017624-1-andriin@fb.com>
References: <20190522195053.4017624-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=979 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bash completion for new C btf dump option.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/bash-completion/bpftool | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 50e402a5a9c8..391ded1df8cd 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -639,10 +639,24 @@ _bpftool()
                             return 0
                             ;;
                         *)
-                            if [[ $cword == 6 ]] && [[ ${words[3]} == "map" ]]; then
-                                 COMPREPLY+=( $( compgen -W 'key value kv all' -- \
-                                     "$cur" ) )
-                            fi
+                            # emit extra options
+                            case ${words[3]} in
+                                id|file)
+                                    if [[ $cword > 4 ]]; then
+                                        _bpftool_once_attr 'c'
+                                    fi
+                                    ;;
+                                map|prog)
+                                    if [[ ${words[3]} == "map" ]] && [[ $cword == 6 ]]; then
+                                        COMPREPLY+=( $( compgen -W "key value kv all" -- "$cur" ) )
+                                    fi
+                                    if [[ $cword > 5 ]]; then
+                                        _bpftool_once_attr 'c'
+                                    fi
+                                    ;;
+                                *)
+                                    ;;
+                            esac
                             return 0
                             ;;
                     esac
-- 
2.17.1

