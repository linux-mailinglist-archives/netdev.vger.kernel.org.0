Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E97200756
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 12:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732525AbgFSKyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 06:54:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40434 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732362AbgFSKys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 06:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592564087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6uVmM+RPaY2/k2K9krznbGg7AKPApCZ6PBYMbCZhb3o=;
        b=DjfRj6FPGkRCiSGxuezzvWKKhyAS4Ys9ZbvydnKtJo1DdDNCFcZ5s9IRnQAzxiKb5XMrZH
        Oa4TvgsVaZ9+aMEx6kEJecnUa0nE+rADiY2k4+TxZZE8WPjE12KCZdgCOPY/TSDW3VdDFE
        ovHWQrHNVRM5uCTK8qj5moBKEcxyVE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-iLyGEEd3OqOhXGZv4WmHyA-1; Fri, 19 Jun 2020 06:54:44 -0400
X-MC-Unique: iLyGEEd3OqOhXGZv4WmHyA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E954A1800D42;
        Fri, 19 Jun 2020 10:54:42 +0000 (UTC)
Received: from ovpn-115-30.ams2.redhat.com (ovpn-115-30.ams2.redhat.com [10.36.115.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3CA871661;
        Fri, 19 Jun 2020 10:54:41 +0000 (UTC)
Message-ID: <c5b53444ca4c79b887629c93d954dadbc4a777da.camel@redhat.com>
Subject: sock diag uAPI and MPTCP
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Date:   Fri, 19 Jun 2020 12:54:40 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

IPPROTO_MPTCP value (0x106) can't be represented using the current sock
diag uAPI, as the 'sdiag_protocol' field is 8 bits wide.

To implement diag support for MPTCP socket, we will likely need a
'inet_diag_req_v3' with a wider 'sdiag_protocol'
field. inet_diag_handler_cmd() could detect the version of
the inet_diag_req_v* provided by user-space checking nlmsg_len() and
convert _v2 reqs to _v3.

This change will be a bit invasive, as all in kernel diag users will
then operate only on 'inet_diag_req_v3' (many functions' signature
change required), but the code-related changes will be encapsulated
by inet_diag_handler_cmd().

Would the above be acceptable?

Thanks for any feedback!

Paolo

