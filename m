Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BB842D567
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhJNIxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:53:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229551AbhJNIxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:53:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634201485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=N/PVZSit8aH08UMYaPleFxoGWJ78BZezxI3fvGpGm1c=;
        b=cNo7SL2l/YaFHrd4DUBWBGiimnmvmC3xXLHDrZZ/HQfXDZk8Z5q6VGZ3fphOPGU+FV3ZrO
        nEkUJC/ny5ZXXQyJpIjnBwjs51ZoO9wpRjs3yDOtzw7Ar1ZlvzmQb0vsz7ST2EFcP+f1wp
        H6Zv4keO9AZWPLJEtVxy7TqvFl5zJRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-LqXrUIl7P_Wy1X47ZgWjBQ-1; Thu, 14 Oct 2021 04:51:22 -0400
X-MC-Unique: LqXrUIl7P_Wy1X47ZgWjBQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9ACFE1006AA2;
        Thu, 14 Oct 2021 08:51:20 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.194.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4E5C7093A;
        Thu, 14 Oct 2021 08:51:17 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v5 0/7] configure: add support for libdir option
Date:   Thu, 14 Oct 2021 10:50:48 +0200
Message-Id: <cover.1634199240.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add support for the libdir parameter in iproute2 configure
script. The idea is to make use of the fact that packaging systems may
assume that 'configure' comes from autotools allowing a syntax similar
to the autotools one, and using it to tell iproute2 where the distro
expects to find its lib files.

Patches 1-2 fix a parsing issue on current configure options, that may
trigger an endless loop when no value is provided with some options;

Patch 3 fixes a parsing issue bailing out when more than one value is
provided for a single option;

Patch 4 simplifies options parsing, moving semantic checks out of the
while loop processing options;

Patch 5 introduces support for the --opt=value style on current options,
for uniformity;

Patch 6 adds the --prefix option, that may be used by some packaging
systems when calling the configure script;

Patch 7 finally adds the --libdir option, and also drops the static
LIBDIR var from the Makefile.

Changelog:
----------
v4 -> v5
  - bail out when multiple values are provided with a single option
  - simplify option parsing and reduce code duplication, as suggested
    by Phil Sutter
  - remove a nasty eval on libdir option processing

v3 -> v4
  - fix parsing issue on '--include_dir' and '--libbpf_dir'
  - split '--opt value' and '--opt=value' use cases, avoid code
    duplication moving semantic checks on value to dedicated functions

v2 -> v3
  - fix parsing error on prefix and libdir options.

v1 -> v2
  - consolidate '--opt value' and '--opt=value' use cases, as suggested
    by David Ahern.
  - added patch 2 to manage the --prefix option, used by the Debian
    packaging system, as reported by Luca Boccassi, and use it when
    setting lib directory.

Andrea Claudi (7):
  configure: fix parsing issue on include_dir option
  configure: fix parsing issue on libbpf_dir option
  configure: fix parsing issue with more than one value per option
  configure: simplify options parsing
  configure: support --param=value style
  configure: add the --prefix option
  configure: add the --libdir option

 Makefile  |  7 ++---
 configure | 78 +++++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 63 insertions(+), 22 deletions(-)

-- 
2.31.1

