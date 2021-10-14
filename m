Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A9E42D56A
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 10:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhJNIxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 04:53:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229997AbhJNIxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 04:53:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634201492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=srTbVX9mwHLeJTPcJh7YEQWzCJSRjkZL38WldLHRC4E=;
        b=HupvDKvM3Pfu/ceBLeO8DzZVpM0MtnZsgDSIHakSPJK89kVjuwKo8KZxKeE227a5BQ30UB
        HuYGM2SvcHABTVAEbItk6UR3Zxnv/+B1/sX5eEUyFgY7hKsg7cedq5X603y+JxWUDjCKmj
        dJzlxUij/gu0GSggXKEjFf7jBCsg1vc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-suO_VLz8O0y2o0i338cmrQ-1; Thu, 14 Oct 2021 04:51:29 -0400
X-MC-Unique: suO_VLz8O0y2o0i338cmrQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06DA5802C94;
        Thu, 14 Oct 2021 08:51:28 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.194.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E19F1B42C;
        Thu, 14 Oct 2021 08:51:25 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, bluca@debian.org,
        phil@nwl.cc, haliu@redhat.com
Subject: [PATCH iproute2 v5 3/7] configure: fix parsing issue with more than one value per option
Date:   Thu, 14 Oct 2021 10:50:51 +0200
Message-Id: <59c4edf70811ab7589d453f8652eb206e1aac5aa.1634199240.git.aclaudi@redhat.com>
In-Reply-To: <cover.1634199240.git.aclaudi@redhat.com>
References: <cover.1634199240.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit a9c3d70d902a ("configure: add options ability") users are no
more able to provide wrong command lines like:

$ ./configure --include_dir foo bar

The script simply bails out when user provides more than one value for a
single option. However, in doing so, it breaks backward compatibility with
some packaging system, which expects unknown options to be ignored.

Commit a3272b93725a ("configure: restore backward compatibility") fix this
issue, but makes it possible again for users to provide wrong command lines
such as the one above.

This fixes the issue simply ignoring autoconf-like options such as
'--opt=value'.

Fixes: a3272b93725a ("configure: restore backward compatibility")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 configure | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/configure b/configure
index 0f304206..9ec19a5b 100755
--- a/configure
+++ b/configure
@@ -517,10 +517,12 @@ else
 				shift 2 ;;
 			-h | --help)
 				usage 0 ;;
+			--*)
+				shift ;;
 			"")
 				break ;;
 			*)
-				shift 1 ;;
+				usage 1 ;;
 		esac
 	done
 fi
-- 
2.31.1

