Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A262F5AF2E9
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 19:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiIFRlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 13:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiIFRlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 13:41:37 -0400
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869A52E3;
        Tue,  6 Sep 2022 10:41:36 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4MMWnk4VQ9z9xrp6;
        Wed,  7 Sep 2022 00:59:22 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwA34JNSfRdjftYoAA--.8234S8;
        Tue, 06 Sep 2022 18:04:31 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, mykolal@fb.com,
        shuah@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jakub@cloudflare.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, houtao1@huawei.com,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 6/7] selftests/bpf: Ensure fd modes are checked for map iters and destroy links
Date:   Tue,  6 Sep 2022 19:03:00 +0200
Message-Id: <20220906170301.256206-7-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
References: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: LxC2BwA34JNSfRdjftYoAA--.8234S8
X-Coremail-Antispam: 1UD129KBjvJXoWxWw4rJw1UtFykAr17WFWxJFb_yoW5CF4Upa
        n5X34YkF4rXa1UuwsxG3y3CrWaqF18WF1UGF9xGry5Zr1DXr93XF10gF1IyF9xAFWkAFWf
        uw4ayw15Gr1UZFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
        Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
        rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
        AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E
        14v26F4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I
        80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCj
        c4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4
        kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E
        5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZV
        WrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY
        1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67
        AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26F4UJVW0obIYCTnIWIevJa73UjIFyTuY
        vjxUsS_MDUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAHBF1jj4KtUAAAsM
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Add an additional check in do_read_map_iter_fd(), to ensure that map
iterators requiring read-write access to a map cannot be created when they
receive as input a read-only fd. Do it for array maps, sk storage maps and
sock maps.

Allowing that operation could result in a map update operation not
authorized by LSMs (since they were asked for read-only access).

Finally, destroy the link when it is not supposed to be created.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 34 +++++++++++++++++--
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
index e89685bd587c..b2d067d38f47 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -72,10 +72,38 @@ static void do_read_map_iter_fd(struct bpf_object_skeleton **skel, struct bpf_pr
 				struct bpf_map *map)
 {
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	struct bpf_map_info info_m = { 0 };
+	__u32 info_m_len = sizeof(info_m);
 	union bpf_iter_link_info linfo;
 	struct bpf_link *link;
 	char buf[16] = {};
 	int iter_fd, len;
+	int ret, fd;
+
+	DECLARE_LIBBPF_OPTS(bpf_get_fd_opts, fd_opts_rdonly,
+		.open_flags = BPF_F_RDONLY,
+	);
+
+	ret = bpf_obj_get_info_by_fd(bpf_map__fd(map), &info_m, &info_m_len);
+	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
+		return;
+
+	fd = bpf_map_get_fd_by_id_opts(info_m.id, &fd_opts_rdonly);
+	if (!ASSERT_GE(fd, 0, "bpf_map_get_fd_by_id_opts"))
+		return;
+
+	memset(&linfo, 0, sizeof(linfo));
+	linfo.map.map_fd = fd;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+	link = bpf_program__attach_iter(prog, &opts);
+
+	close(fd);
+
+	if (!ASSERT_ERR_PTR(link, "attach_map_iter")) {
+		bpf_link__destroy(link);
+		return;
+	}
 
 	memset(&linfo, 0, sizeof(linfo));
 	linfo.map.map_fd = bpf_map__fd(map);
@@ -656,12 +684,12 @@ static void test_bpf_hash_map(void)
 	opts.link_info_len = sizeof(linfo);
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts);
 	if (!ASSERT_ERR_PTR(link, "attach_iter"))
-		goto out;
+		goto free_link;
 
 	linfo.map.map_fd = bpf_map__fd(skel->maps.hashmap3);
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts);
 	if (!ASSERT_ERR_PTR(link, "attach_iter"))
-		goto out;
+		goto free_link;
 
 	/* hashmap1 should be good, update map values here */
 	map_fd = bpf_map__fd(skel->maps.hashmap1);
@@ -683,7 +711,7 @@ static void test_bpf_hash_map(void)
 	linfo.map.map_fd = map_fd;
 	link = bpf_program__attach_iter(skel->progs.sleepable_dummy_dump, &opts);
 	if (!ASSERT_ERR_PTR(link, "attach_sleepable_prog_to_iter"))
-		goto out;
+		goto free_link;
 
 	linfo.map.map_fd = map_fd;
 	link = bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts);
-- 
2.25.1

