Return-Path: <netdev+bounces-5727-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3D1471292C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:10:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A168281820
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4C8261F2;
	Fri, 26 May 2023 15:10:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CCA848B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:10:14 +0000 (UTC)
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C166C9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:10:12 -0700 (PDT)
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
	by m0050093.ppops.net-00190b01. (8.17.1.19/8.17.1.19) with ESMTP id 34QANkiL027107;
	Fri, 26 May 2023 16:10:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=2w50U69UP18CfjIcRlby+s8eFu5Zx5b65FIaLFXxIh0=;
 b=U7b6vLHv0nD8irPTHh5ZUgd00aIDdqwbanUwnGjGxX/8hZyyTC0StJ3KcUQ7MFrfyyQH
 yoIj1RHnzzJWUO92r94kKBHm0KHgDzswuKio3rjr6k/VgwDpqa/CksskqSSLB9cQaXTR
 nsqN1b4GMyMjaDK1IotGs7/rNgitEPJFttzOZ5gJEZeDEKla5glM7kPK2PJlxOjLQGCE
 BMo/4uSVPHufQfn+noitTkd6BoXFJ99b55W3vOzxTBCOLRyMD/2MYM3MK0KSIMJpI9ac
 7chQ2akpMP0JqMOKGnxWdFCXDQtomN1/iyXakd+SAuL8bJCBCc5fvrdSEd6lcn/IARps Kw== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
	by m0050093.ppops.net-00190b01. (PPS) with ESMTPS id 3qtmpqfj8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 May 2023 16:10:11 +0100
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
	by prod-mail-ppoint5.akamai.com (8.17.1.19/8.17.1.19) with ESMTP id 34QE5kWe014971;
	Fri, 26 May 2023 08:10:09 -0700
Received: from email.msg.corp.akamai.com ([172.27.91.24])
	by prod-mail-ppoint5.akamai.com (PPS) with ESMTPS id 3qpv698jxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 May 2023 08:10:09 -0700
Received: from bos-lhv018.bos01.corp.akamai.com (172.28.222.198) by
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 26 May 2023 11:10:09 -0400
From: Max Tottenham <mtottenh@akamai.com>
To: <netdev@vger.kernel.org>
CC: <stephen@networkplumber.org>, <johunt@akamai.com>,
        Max Tottenham
	<mtottenh@akamai.com>
Subject: [RFC PATCH v2 iproute2 1/1] tc/f_bpf.c: Add ability to specify eBPF map pin path
Date: Fri, 26 May 2023 11:09:21 -0400
Message-ID: <20230526150921.338906-2-mtottenh@akamai.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230526150921.338906-1-mtottenh@akamai.com>
References: <20230503173348.703437-1-mtottenh@akamai.com>
 <20230526150921.338906-1-mtottenh@akamai.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.28.222.198]
X-ClientProxiedBy: usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) To
 usma1ex-dag4mb5.msg.corp.akamai.com (172.27.91.24)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_06,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=793 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260127
X-Proofpoint-GUID: 8sC8GRzSdV9nauFMsvYjSJ_-YIveERas
X-Proofpoint-ORIG-GUID: 8sC8GRzSdV9nauFMsvYjSJ_-YIveERas
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_06,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=791 phishscore=0 adultscore=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305260128
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Allow users of TCs eBPF classifier to specify a path for pinning eBPF
maps via the use of the 'pin_path' argument. For example:

tc -filter add dev ens3 ingress bpf object-file ./bpf_shared.o section \
  ingress pin_path /sys/fs/bpf/my_prog verbose da

Will create/pin any maps under /sys/fs/bpf/my_prog/..., or reuse
existing maps there if present.

Signed-off-by: Max Tottenham <mtottenh@akamai.com>
---
 include/bpf_util.h |  1 +
 lib/bpf_legacy.c   | 11 +++++++++--
 lib/bpf_libbpf.c   | 14 +++++++-------
 man/man8/tc-bpf.8  |  8 ++++++++
 tc/f_bpf.c         |  4 +++-
 5 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/include/bpf_util.h b/include/bpf_util.h
index 6a5f8ec6..e7ad643b 100644
--- a/include/bpf_util.h
+++ b/include/bpf_util.h
@@ -70,6 +70,7 @@ struct bpf_cfg_in {
 	const char *section;
 	const char *prog_name;
 	const char *uds;
+	const char *pin_path;
 	enum bpf_prog_type type;
 	enum bpf_mode mode;
 	__u32 ifindex;
diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 8ac64235..18b2760c 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -827,7 +827,7 @@ static int bpf_obj_pinned(const char *pathname, enum bpf_prog_type type)
 
 static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 {
-	const char *file, *section, *uds_name, *prog_name;
+	const char *file, *section, *uds_name, *prog_name, *pin_path;
 	bool verbose = false;
 	int i, ret, argc;
 	char **argv;
@@ -858,7 +858,7 @@ static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 	}
 
 	NEXT_ARG();
-	file = section = uds_name = prog_name = NULL;
+	file = section = uds_name = prog_name = pin_path = NULL;
 	if (cfg->mode == EBPF_OBJECT || cfg->mode == EBPF_PINNED) {
 		file = *argv;
 		NEXT_ARG_FWD();
@@ -901,6 +901,12 @@ static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 			NEXT_ARG_FWD();
 		}
 
+		if (argc > 0 && strcmp(*argv, "pin_path") == 0) {
+			NEXT_ARG();
+			pin_path = *argv;
+			NEXT_ARG_FWD();
+		}
+
 		if (__bpf_prog_meta[cfg->type].may_uds_export) {
 			uds_name = getenv(BPF_ENV_UDS);
 			if (argc > 0 && !uds_name &&
@@ -939,6 +945,7 @@ static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 	cfg->argv    = argv;
 	cfg->verbose = verbose;
 	cfg->prog_name = prog_name;
+	cfg->pin_path = pin_path;
 
 	return ret;
 }
diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
index e1c211a1..9cfd4561 100644
--- a/lib/bpf_libbpf.c
+++ b/lib/bpf_libbpf.c
@@ -226,7 +226,6 @@ static int handle_legacy_maps(struct bpf_object *obj)
 
 	bpf_object__for_each_map(map, obj) {
 		map_name = bpf_map__name(map);
-
 		ret = handle_legacy_map_in_map(obj, map, map_name);
 		if (ret)
 			return ret;
@@ -277,16 +276,17 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
 	char root_path[PATH_MAX];
 	struct bpf_map *map;
 	int prog_fd, ret = 0;
-
-	ret = iproute2_get_root_path(root_path, PATH_MAX);
-	if (ret)
-		return ret;
-
+	if (cfg->pin_path) {
+		strncpy(root_path , cfg->pin_path, PATH_MAX-1);
+	} else {
+		ret = iproute2_get_root_path(root_path, PATH_MAX);
+		if (ret)
+			return ret;
+	}
 	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, open_opts,
 			.relaxed_maps = true,
 			.pin_root_path = root_path,
 	);
-
 	obj = bpf_object__open_file(cfg->object, &open_opts);
 	if (libbpf_get_error(obj)) {
 		fprintf(stderr, "ERROR: opening BPF object file failed\n");
diff --git a/man/man8/tc-bpf.8 b/man/man8/tc-bpf.8
index 01230ce6..df2e87e6 100644
--- a/man/man8/tc-bpf.8
+++ b/man/man8/tc-bpf.8
@@ -22,6 +22,8 @@ UDS_FILE ] [
 |
 .B skip_sw
 ] [
+.B pin_path
+PATH ] [
 .B police
 POLICE_SPEC ] [
 .B action
@@ -189,6 +191,12 @@ forces the offload and disables running the eBPF program in the kernel.
 If hardware offload is not possible and this flag was set kernel will
 report an error and filter will not be installed at all.
 
+.SS pin_path
+points to a path under bpffs. On loading an eBPF object file, if the file
+contains a section named "maps" with eBPF map specifications, this path will be
+checked for existing pinned maps with matching names. If existing maps are
+found, they will be reused.
+
 .SS police
 is an optional parameter for an eBPF/cBPF classifier that specifies a
 police in
diff --git a/tc/f_bpf.c b/tc/f_bpf.c
index a6d4875f..9f121b00 100644
--- a/tc/f_bpf.c
+++ b/tc/f_bpf.c
@@ -28,7 +28,7 @@ static void explain(void)
 		"\n"
 		"eBPF use case:\n"
 		" object-file FILE [ section CLS_NAME ] [ export UDS_FILE ]"
-		" [ verbose ] [ direct-action ] [ skip_hw | skip_sw ]\n"
+		" [ verbose ] [ direct-action ] [ skip_hw | skip_sw ] [ pin_path PATH ]\n"
 		" object-pinned FILE [ direct-action ] [ skip_hw | skip_sw ]\n"
 		"\n"
 		"Common remaining options:\n"
@@ -48,6 +48,8 @@ static void explain(void)
 		"Where UDS_FILE points to a unix domain socket file in order\n"
 		"to hand off control of all created eBPF maps to an agent.\n"
 		"\n"
+		"Where PATH points to a path under bpffs where all eBPF maps will be pinned.\n"
+		"\n"
 		"ACTION_SPEC := ... look at individual actions\n"
 		"NOTE: CLASSID is parsed as hexadecimal input.\n",
 		bpf_prog_to_default_section(bpf_type));
-- 
2.25.1


