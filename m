Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879631E9D51
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 07:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgFAF0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 01:26:39 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19602 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgFAF0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 01:26:38 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed491820001>; Sun, 31 May 2020 22:26:26 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sun, 31 May 2020 22:26:38 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sun, 31 May 2020 22:26:38 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Jun
 2020 05:26:38 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Jun 2020 05:26:37 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.56.10]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ed4918c0004>; Sun, 31 May 2020 22:26:37 -0700
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v2 0/2] vhost, docs: convert to pin_user_pages(), new "case 5"
Date:   Sun, 31 May 2020 22:26:31 -0700
Message-ID: <20200601052633.853874-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590989186; bh=oWhDekDqxx6fP3u/Pk90DFNTa0Jiv5OSfwybT44Pq1M=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Type:
         Content-Transfer-Encoding;
        b=njQ2XrKfA5W2d6S2irff3GXFlkhESnmMzdRVd0Q/6B60AxagwtZSbLa4o+uUZPcEC
         U9b4toQeqtCH2JLxeEdlYli0rRsWaLGGgu7lNzOE4A3V9yIjpiUmL++Z39WzDX8gm2
         Y+SEzR/8oWDaFDEpzI6OOPvRCeV1MdbdreDatwd//9coer0YaPfJARKz6KpKuJNuki
         i9df1soJa3Ku0wAC2kh8rE6HVP5UIGoO2FLioKhbkYmm1zpPOCFOrf+L8Fzx/m1u67
         U87MTtgDiMhF3FWGCf9o8p0f0Fzq6zhQsQoCWpyZ5HjHySh/7RDgDY46C0swvVZLfy
         +vVIjKS1sWtVQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is based on Linux 5.7, plus one prerequisite patch:
   "mm/gup: update pin_user_pages.rst for "case 3" (mmu notifiers)" [1]

Changes since v1: removed references to set_page_dirty*(), in response to
Souptick Joarder's review (thanks!).

Cover letter for v1, edited/updated slightly:

It recently became clear to me that there are some get_user_pages*()
callers that don't fit neatly into any of the four cases that are so
far listed in pin_user_pages.rst. vhost.c is one of those.

Add a Case 5 to the documentation, and refer to that when converting
vhost.c.

Thanks to Jan Kara for helping me (again) in understanding the
interaction between get_user_pages() and page writeback [2].

Note that I have only compile-tested the vhost.c patch, although that
does also include cross-compiling for a few other arches. Any run-time
testing would be greatly appreciated.

[1] https://lore.kernel.org/r/20200527194953.11130-1-jhubbard@nvidia.com
[2] https://lore.kernel.org/r/20200529070343.GL14550@quack2.suse.cz

John Hubbard (2):
  docs: mm/gup: pin_user_pages.rst: add a "case 5"
  vhost: convert get_user_pages() --> pin_user_pages()

 Documentation/core-api/pin_user_pages.rst | 18 ++++++++++++++++++
 drivers/vhost/vhost.c                     |  5 ++---
 2 files changed, 20 insertions(+), 3 deletions(-)


base-commit: 3d77e6a8804abcc0504c904bd6e5cdf3a5cf8162
--=20
2.26.2

