Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D527410CC7E
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 17:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfK1QIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 11:08:55 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33443 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbfK1QIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 11:08:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574957333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=CXzG1J/CFbsb4K3v/udO4wLVNEiWZJys9gAPx1PG8ro=;
        b=f5fgFDybBIK7X2aNHM3/GLbzMDXEVWsYEc7oeybWPZzFjMne7LaHHtAM144rm/zwTwAgNm
        1coJQ9CmqMP7mnUBLRvP7n8C1biDMHYk3W1CWcnu7T5YWuG8L7Cme/vt8/7+m1yyHO9tyK
        wT5i/WY2q9FICHRIJ2z10yUrCHzMdwM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-TVBSW2wSOwmCZrTB49WmYA-1; Thu, 28 Nov 2019 11:08:49 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B6B8800EBA;
        Thu, 28 Nov 2019 16:08:48 +0000 (UTC)
Received: from carbon (unknown [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8ED1210013A7;
        Thu, 28 Nov 2019 16:08:40 +0000 (UTC)
Date:   Thu, 28 Nov 2019 17:08:37 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     brouer@redhat.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Better ways to validate map via BTF?
Message-ID: <20191128170837.2236713b@carbon>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: TVBSW2wSOwmCZrTB49WmYA-1
X-Mimecast-Spam-Score: 0
Content-Type: multipart/mixed; boundary="MP_/T92jVa0H16EwHN9B/ADyA.+"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/T92jVa0H16EwHN9B/ADyA.+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Andrii,

Is there are better way to validate that a userspace BPF-program uses
the correct map via BTF?

Below and in attached patch, I'm using bpf_obj_get_info_by_fd() to get
some map-info, and check info.value_size and info.max_entries match
what I expect.  What I really want, is to check that "map-value" have
same struct layout as:

 struct config {
	__u32 action;
	int ifindex;
	__u32 options;
 };

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


static void check_config_map_fd_info(int map_fd) {
	struct bpf_map_info info = { 0 };
	__u32 info_len = sizeof(info);
	__u32 exp_value_size = sizeof(struct config);
	__u32 exp_entries = 1;
	int err;

	/* BPF-info via bpf-syscall */
	err = bpf_obj_get_info_by_fd(map_fd, &info, &info_len);
	if (err) {
		fprintf(stderr, "ERR: %s() can't get info - %s\n",
			__func__,  strerror(errno));
		exit(EXIT_FAIL_BPF);
	}

	if (exp_value_size != info.value_size) {
		fprintf(stderr, "ERR: %s() "
			"Map value size(%d) mismatch expected size(%d)\n",
			__func__, info.value_size, exp_value_size);
		exit(EXIT_FAIL_BPF);
	}

	if (exp_entries != info.max_entries) {
		fprintf(stderr, "ERR: %s() "
			"Map max_entries(%d) mismatch expected entries(%d)\n",
			__func__, info.max_entries, exp_entries);
		exit(EXIT_FAIL_BPF);
	}
}


struct config {
	__u32 action;
	int ifindex;
	__u32 options;
};


--MP_/T92jVa0H16EwHN9B/ADyA.+
Content-Type: application/octet-stream; name=02-detect_map_mismatch
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=02-detect_map_mismatch

c2FtcGxlcy9icGY6IHhkcF9yeHFfaW5mbyBjaGVjayB0aGF0IG1hcCBoYXZlIGV4cGVjdGVkIHNp
emUKCkZyb206IEplc3BlciBEYW5nYWFyZCBCcm91ZXIgPGJyb3VlckByZWRoYXQuY29tPgoKU2ln
bmVkLW9mZi1ieTogSmVzcGVyIERhbmdhYXJkIEJyb3VlciA8YnJvdWVyQHJlZGhhdC5jb20+Ci0t
LQogc2FtcGxlcy9icGYveGRwX3J4cV9pbmZvX3VzZXIuYyB8ICAgMzMgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgMzIgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL3NhbXBsZXMvYnBmL3hkcF9yeHFfaW5mb191c2VyLmMg
Yi9zYW1wbGVzL2JwZi94ZHBfcnhxX2luZm9fdXNlci5jCmluZGV4IDUxZTBkODEwZTA3MC4uZmE2
MDczMWZkYmFkIDEwMDY0NAotLS0gYS9zYW1wbGVzL2JwZi94ZHBfcnhxX2luZm9fdXNlci5jCisr
KyBiL3NhbXBsZXMvYnBmL3hkcF9yeHFfaW5mb191c2VyLmMKQEAgLTQ1Myw2ICs0NTMsMzUgQEAg
c3RhdGljIHZvaWQgc3RhdHNfcG9sbChpbnQgaW50ZXJ2YWwsIGludCBhY3Rpb24sIF9fdTMyIGNm
Z19vcHQpCiAJZnJlZV9zdGF0c19yZWNvcmQocHJldik7CiB9CiAKK3N0YXRpYyB2b2lkIGNoZWNr
X2NvbmZpZ19tYXBfZmRfaW5mbyhpbnQgbWFwX2ZkKSB7CisJc3RydWN0IGJwZl9tYXBfaW5mbyBp
bmZvID0geyAwIH07CisJX191MzIgaW5mb19sZW4gPSBzaXplb2YoaW5mbyk7CisJX191MzIgZXhw
X3ZhbHVlX3NpemUgPSBzaXplb2Yoc3RydWN0IGNvbmZpZyk7CisJX191MzIgZXhwX2VudHJpZXMg
PSAxOworCWludCBlcnI7CisKKwkvKiBCUEYtaW5mbyB2aWEgYnBmLXN5c2NhbGwgKi8KKwllcnIg
PSBicGZfb2JqX2dldF9pbmZvX2J5X2ZkKG1hcF9mZCwgJmluZm8sICZpbmZvX2xlbik7CisJaWYg
KGVycikgeworCQlmcHJpbnRmKHN0ZGVyciwgIkVSUjogJXMoKSBjYW4ndCBnZXQgaW5mbyAtICVz
XG4iLAorCQkJX19mdW5jX18sICBzdHJlcnJvcihlcnJubykpOworCQlleGl0KEVYSVRfRkFJTF9C
UEYpOworCX0KKworCWlmIChleHBfdmFsdWVfc2l6ZSAhPSBpbmZvLnZhbHVlX3NpemUpIHsKKwkJ
ZnByaW50ZihzdGRlcnIsICJFUlI6ICVzKCkgIgorCQkJIk1hcCB2YWx1ZSBzaXplKCVkKSBtaXNt
YXRjaCBleHBlY3RlZCBzaXplKCVkKVxuIiwKKwkJCV9fZnVuY19fLCBpbmZvLnZhbHVlX3NpemUs
IGV4cF92YWx1ZV9zaXplKTsKKwkJZXhpdChFWElUX0ZBSUxfQlBGKTsKKwl9CisKKwlpZiAoZXhw
X2VudHJpZXMgIT0gaW5mby5tYXhfZW50cmllcykgeworCQlmcHJpbnRmKHN0ZGVyciwgIkVSUjog
JXMoKSAiCisJCQkiTWFwIG1heF9lbnRyaWVzKCVkKSBtaXNtYXRjaCBleHBlY3RlZCBlbnRyaWVz
KCVkKVxuIiwKKwkJCV9fZnVuY19fLCBpbmZvLm1heF9lbnRyaWVzLCBleHBfZW50cmllcyk7CisJ
CWV4aXQoRVhJVF9GQUlMX0JQRik7CisJfQorfQogCiBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAq
KmFyZ3YpCiB7CkBAIC00NjEsNyArNDkwLDcgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiph
cmd2KQogCXN0cnVjdCBicGZfcHJvZ19sb2FkX2F0dHIgcHJvZ19sb2FkX2F0dHIgPSB7CiAJCS5w
cm9nX3R5cGUJPSBCUEZfUFJPR19UWVBFX1hEUCwKIAl9OwotCXN0cnVjdCBicGZfcHJvZ19pbmZv
IGluZm8gPSB7fTsKKwlzdHJ1Y3QgYnBmX3Byb2dfaW5mbyBpbmZvID0geyAwIH07CiAJX191MzIg
aW5mb19sZW4gPSBzaXplb2YoaW5mbyk7CiAJaW50IHByb2dfZmQsIG1hcF9mZCwgb3B0LCBlcnI7
CiAJYm9vbCB1c2Vfc2VwYXJhdG9ycyA9IHRydWU7CkBAIC00OTAsNiArNTE5LDcgQEAgaW50IG1h
aW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCQlyZXR1cm4gRVhJVF9GQUlMOwogCiAJbWFwID0g
YnBmX21hcF9fbmV4dChOVUxMLCBvYmopOworLy8JbWFwID0gIGJwZl9vYmplY3RfX2ZpbmRfbWFw
X2J5X25hbWUob2JqLCAiY29uZmlnIik7CiAJc3RhdHNfZ2xvYmFsX21hcCA9IGJwZl9tYXBfX25l
eHQobWFwLCBvYmopOwogCXJ4X3F1ZXVlX2luZGV4X21hcCA9IGJwZl9tYXBfX25leHQoc3RhdHNf
Z2xvYmFsX21hcCwgb2JqKTsKIAlpZiAoIW1hcCB8fCAhc3RhdHNfZ2xvYmFsX21hcCB8fCAhcnhf
cXVldWVfaW5kZXhfbWFwKSB7CkBAIC01ODEsNiArNjExLDcgQEAgaW50IG1haW4oaW50IGFyZ2Ms
IGNoYXIgKiphcmd2KQogCQlzZXRsb2NhbGUoTENfTlVNRVJJQywgImVuX1VTIik7CiAKIAkvKiBV
c2VyLXNpZGUgc2V0dXAgaWZpbmRleCBpbiBjb25maWdfbWFwICovCisJY2hlY2tfY29uZmlnX21h
cF9mZF9pbmZvKG1hcF9mZCk7CiAJZXJyID0gYnBmX21hcF91cGRhdGVfZWxlbShtYXBfZmQsICZr
ZXksICZjZmcsIDApOwogCWlmIChlcnIpIHsKIAkJZnByaW50ZihzdGRlcnIsICJTdG9yZSBjb25m
aWcgZmFpbGVkIChlcnI6JWQpXG4iLCBlcnIpOwo=
--MP_/T92jVa0H16EwHN9B/ADyA.+--

