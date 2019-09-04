Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0815A8172
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 13:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbfIDLt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 07:49:28 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44638 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfIDLt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 07:49:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so11109016pgl.11;
        Wed, 04 Sep 2019 04:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=shoUwDqLr310eJk91YJF4EppjGh0Fisx8iWq37S83vk=;
        b=ioB7UE5VRVoQGx4VYTZOVpzYDft0sVBvHoPHFun6tN1p1ZYmWegcF8lBw1biYlLxE+
         bqQ1R2MVKFe0R8nwWYLhQvWi0tUfKFMMIO9wKNTZJQw2gXSC+KlZ8HkIJGFIEOqekoCF
         zbc2dtzR9DXvIkAVCvVQjBnvLf3tGUErgaV3BEXVBzDCKlwrmZVELbpGDJg/zCZJ8rDT
         s7NvG+i6BBdkJGj/VlMGT00ZDx+OiXSB+2jyGDqsRDFCosotE+EOIm7OfcPscYZmtQaZ
         Xalh/Z6wqKb2XE42VhegavUMj4hefFXP1j//J7O2fAZ0XhCtil8sOFt0610E7XAG5JHc
         arbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=shoUwDqLr310eJk91YJF4EppjGh0Fisx8iWq37S83vk=;
        b=RYx0a/Y1m0XhcYSPxTbqa4hTFognOlT4fID/wuQAs2MQqmvuOwUlfp0dZTk2UYksfT
         BDzWuznZtqVF2r2fw88uL1zgIZnTh7e4Hqb8Ca9c1OHhNk3KnLAIW8QL/aDhS+b1dp9u
         y+emKVZfuKZL/H/NmsQtoSTGHGZ+u80ZxTpP2/Eb9CpoGl2XiBJKA5mc4Tc5d4WWUJLq
         6XG5vGcb+danRK6PxChmPhFp7+eA0oHUwJrAgTkfYo6mUYXAcAua6EuocVZjs6OHlOaD
         usZWqRN7L9nibBm6enlW7vyeP7ksXalzgSK8zIgY+5r3jw0pU0ZGogstW2ypFaaYkW84
         lzDA==
X-Gm-Message-State: APjAAAWnRwCGqb1LaWlSpVh+fuy8IWSbY3IaCz/Tu39LmP4URR/rcnGv
        kSRjnjTia3AfDyN9fI9uFA4=
X-Google-Smtp-Source: APXvYqyn5h9DmOoaWXxhsEQ4LB4GP2Dk0vDBy3um1djGKx1pHsMrATDkgmA7w96U06rewLk5ZpNHrw==
X-Received: by 2002:a65:63c4:: with SMTP id n4mr34306743pgv.44.1567597766906;
        Wed, 04 Sep 2019 04:49:26 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.54.39])
        by smtp.gmail.com with ESMTPSA id b126sm48257008pfa.177.2019.09.04.04.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 04:49:26 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, bjorn.topel@intel.com,
        jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next v3 0/4] xsk: various CPU barrier and {READ, WRITE}_ONCE
Date:   Wed,  4 Sep 2019 13:49:09 +0200
Message-Id: <20190904114913.17217-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a four patch series of various barrier, {READ, WRITE}_ONCE
cleanups in the AF_XDP socket code. More details can be found in the
corresponding commit message. Previous revisions: v1 [4] and v2 [5].

For an AF_XDP socket, most control plane operations are done under the
control mutex (struct xdp_sock, mutex), but there are some places
where members of the struct is read outside the control mutex. The
dev, queue_id members are set in bind() and cleared at cleanup. The
umem, fq, cq, tx, rx, and state member are all assigned in various
places, e.g. bind() and setsockopt(). When the members are assigned,
they are protected by the control mutex, but since they are read
outside the mutex, a WRITE_ONCE is required to avoid store-tearing on
the read-side.

Prior the state variable was introduced by Ilya, the dev member was
used to determine whether the socket was bound or not. However, when
dev was read, proper SMP barriers and READ_ONCE were missing. In order
to address the missing barriers and READ_ONCE, we start using the
state variable as a point of synchronization. The state member
read/write is paired with proper SMP barriers, and from this follows
that the members described above does not need READ_ONCE statements if
used in conjunction with state check.

To summarize: The members struct xdp_sock members dev, queue_id, umem,
fq, cq, tx, rx, and state were read lock-less, with incorrect barriers
and missing {READ, WRITE}_ONCE. After this series umem, fq, cq, tx,
rx, and state are read lock-less. When these members are updated,
WRITE_ONCE is used. When read, READ_ONCE are only used when read
outside the control mutex (e.g. mmap) or, not synchronized with the
state member (XSK_BOUND plus smp_rmb())

Thanks,
Björn

[1] https://lore.kernel.org/bpf/beef16bb-a09b-40f1-7dd0-c323b4b89b17@iogearbox.net/
[2] https://lwn.net/Articles/793253/
[3] https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE
[4] https://lore.kernel.org/bpf/20190822091306.20581-1-bjorn.topel@gmail.com/
[5] https://lore.kernel.org/bpf/20190826061053.15996-1-bjorn.topel@gmail.com/

v2->v3:
  Minor restructure of commits.
  Improve cover and commit messages. (Daniel)
v1->v2:
  Removed redundant dev check. (Jonathan)

Björn Töpel (4):
  xsk: avoid store-tearing when assigning queues
  xsk: avoid store-tearing when assigning umem
  xsk: use state member for socket synchronization
  xsk: lock the control mutex in sock_diag interface

 net/xdp/xsk.c      | 60 ++++++++++++++++++++++++++++++++--------------
 net/xdp/xsk_diag.c |  3 +++
 2 files changed, 45 insertions(+), 18 deletions(-)

-- 
2.20.1

