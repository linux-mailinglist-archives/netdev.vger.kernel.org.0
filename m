Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C89CAB32E
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391719AbfIFHbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52072 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732504AbfIFHbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 03:31:48 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A017180041A;
        Fri,  6 Sep 2019 07:31:47 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.205.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B16D160126;
        Fri,  6 Sep 2019 07:31:45 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 0/7] libbpf: Fix cast away const qualifiers in btf.h
Date:   Fri,  6 Sep 2019 09:31:37 +0200
Message-Id: <20190906073144.31068-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Fri, 06 Sep 2019 07:31:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
when including btf.h in bpftrace, I'm getting -Wcast-qual warnings like:

  bpf/btf.h: In function ‘btf_var_secinfo* btf_var_secinfos(const btf_type*)’:
  bpf/btf.h:302:41: warning: cast from type ‘const btf_type*’ to type
  ‘btf_var_secinfo*’ casts away qualifiers [-Wcast-qual]
    302 |  return (struct btf_var_secinfo *)(t + 1);
        |                                         ^

I changed the btf.h header to comply with -Wcast-qual checks
and used const cast away casting in libbpf objects, where it's
all related to deduplication code, so I believe loosing const
is fine there.

thanks,
jirka


---
Jiri Olsa (7):
      libbpf: Use const cast for btf_int_* functions
      libbpf: Return const btf_array from btf_array inline function
      libbpf: Return const btf_enum from btf_enum inline function
      libbpf: Return const btf_member from btf_members inline function
      libbpf: Return const btf_param from btf_params inline function
      libbpf: Return const btf_var from btf_var inline function
      libbpf: Return const struct btf_var_secinfo from btf_var_secinfos inline function

 tools/lib/bpf/btf.c    | 21 +++++++++++----------
 tools/lib/bpf/btf.h    | 30 +++++++++++++++---------------
 tools/lib/bpf/libbpf.c |  2 +-
 3 files changed, 27 insertions(+), 26 deletions(-)
