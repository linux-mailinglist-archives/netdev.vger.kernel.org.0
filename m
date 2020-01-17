Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5AF140440
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 08:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgAQHJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 02:09:19 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40225 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgAQHJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 02:09:19 -0500
Received: by mail-pf1-f193.google.com with SMTP id q8so11498297pfh.7;
        Thu, 16 Jan 2020 23:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wdv4lG5+idVQ+m2cyNBbBqOOGD1eK0711ACf52RUIc4=;
        b=aJsOM28dpXZ3E8yQPEOztAAKh0xpxCFLkhTYwaEHs1EcjRoDAExICyUaKCl8eQcgBt
         lRcGlYh5+dsIp4iz4iwJ2CXT9EZwzAkDdA7hp9dmyl/yK5HoTYtSdRohMolNyBot7Efk
         bj9xgcy/TOeSmFb0xlOvfjdrGlpTrWH57/UJFrXoytseafv+bkKQF77f3HOQCcY+H+qj
         PSZsQ/ZOGQiFKF3JzA0OAHfDa0QFFcGemYyADSXY/n3aVaRTR+vidF3hF/NF0n2v1Aaw
         FdTq38fCusX6btAcYpFwxdc8xqcLiySKC5f3yTeybVCuRsvRL+wygRYr5V2XVDmSreAn
         6Tlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wdv4lG5+idVQ+m2cyNBbBqOOGD1eK0711ACf52RUIc4=;
        b=T/bxpF5FOW52pXySmdSJ4Yw+YOohzLAHzHuli1ke7IbmzW33UUCC4V/ZSdKG37yHCH
         5LMkbO/FZGondGw1N3xpP8Y9g2nDGkjpDYgW1JyZOwVdXouAFjXrNNWvZ3VIVUeCBJim
         Xc0DcgTzlbvrOqJebLKVNQY28GkDzJhEwRKqIbytf8B8pCNdaop8EJuNw9kEEh66LJdO
         mVudPxerYwIqMmzTkZgiUqJVXutZc0C+feYUvbRU/3U1WPZ9lG1SBID4h9wX+LZS3fZh
         2s8ZiF5OBKNwCjHbS9wWB4QbWvJ2km7p+I3vHyd1YARHSp1kOSOWek5IDO8b44rZvwvv
         XL+Q==
X-Gm-Message-State: APjAAAWBecQu2vXLzaI40reCPhYHI7StPjhXGGhGm0rNmYZfu7P4YPU1
        SwC9RQZ/hFpY6fF7iuIPI+s=
X-Google-Smtp-Source: APXvYqyb3bj9M993s5Sv5HFGu85yqw17yOfL9aJ9YFe1aQO9yygQMB0RMdH04XKyhJ5Yhytjze+r8w==
X-Received: by 2002:a63:4e06:: with SMTP id c6mr43239499pgb.187.1579244958036;
        Thu, 16 Jan 2020 23:09:18 -0800 (PST)
Received: from hpg8-3.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d4sm407499pjg.19.2020.01.16.23.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 23:09:17 -0800 (PST)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2 bpf 0/2] Fix the classification based on port ranges in bpf hook
Date:   Fri, 17 Jan 2020 16:05:31 +0900
Message-Id: <20200117070533.402240-1-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When I tried a test based on the selftest program for BPF flow dissector
(test_flow_dissector.sh), I observed unexpected result as below:

$ tc filter add dev lo parent ffff: protocol ip pref 1337 flower ip_proto \
	udp src_port 8-10 action drop
$ tools/testing/selftests/bpf/test_flow_dissector -i 4 -f 9 -F
inner.dest4: 127.0.0.1
inner.source4: 127.0.0.3
pkts: tx=10 rx=10

The last rx means the number of received packets. I expected rx=0 in this
test (i.e., all received packets should have been dropped), but it resulted
in acceptance.

Although the previous commit 8ffb055beae5 ("cls_flower: Fix the behavior
using port ranges with hw-offload") added new flag and field toward filtering
based on port ranges with hw-offload, it missed applying for BPF flow dissector
then. As a result, BPF flow dissector currently stores data extracted from
packets in incorrect field used for exact match whenever packets are classified
by filters based on port ranges. Thus, they never match rules in such cases
because flow dissector gives rise to generating incorrect flow keys.

This series fixes the issue by replacing incorrect flag and field with new 
ones in BPF flow dissector, and adds a test for filtering based on specified
port ranges to the existing selftest program.

Changes in v2:
 - set key_ports to NULL at the top of __skb_flow_bpf_to_target()

Yoshiki Komachi (2):
  flow_dissector: Fix to use new variables for port ranges in bpf hook
  selftests/bpf: Add test based on port range for BPF flow dissector

 net/core/flow_dissector.c                          |  9 ++++++++-
 tools/testing/selftests/bpf/test_flow_dissector.sh | 14 ++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

-- 
1.8.3.1

