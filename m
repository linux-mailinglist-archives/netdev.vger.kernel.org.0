Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F4C41375A
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbhIUQTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234621AbhIUQSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:18:49 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE7BC0613DE;
        Tue, 21 Sep 2021 09:17:16 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id v24so76389473eda.3;
        Tue, 21 Sep 2021 09:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PZHGXm7R/JEU6vc8GKEW973CLXt7h16wy5g4hm2R7wo=;
        b=qpEocCGtIbmPIBOY44TbpBrFLusxsaxnRppUrrkcvnDdz1iN4RLSCJxLa7YpvF5jrf
         CaNUfIOy8K56UE07kHh62MXFL5lUQfF2G+KJwuY3McPbVAa9RvkTekAys1nsz+12PSmU
         v3wlZcFsbitT5DjmIRRoVYJxWh2qnk1qixwz5wpj+Sp9asNbK7r2Bs652rwqHsqNvZuj
         dajGxjnE4luLPFIfWKgGP9/L0/d5+iZDrlFZbIybB3QYtd3gOidXeRxHq7FZn+qoV1C4
         FHlcgqvNqUBgPvrUxmmF/NeOx7g6YD3NCliqeXE4Q8zwKEwkyxSNV9waNujgfqR1WzgG
         fOsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PZHGXm7R/JEU6vc8GKEW973CLXt7h16wy5g4hm2R7wo=;
        b=NMB0AdI9p/tYeXvz7DJq/T7ySqLc/6A3CBc0PQCe8OeIZIukWd3GaXgJX4mLBLeAbD
         m6RTQmEXE21zjRRV3WjdICl8Xv+oCnddXn7iM8Z1eY3d0yM+6TgR7XBbJNPxjy61GvCj
         HDBoOeqcTkglfMBYH79XK28WLXRTmRkvTqo4Ll4JnNiyaD8GeduOmmDnIru1JSJ+3dZ3
         +15EJISY9btnEg7Xl4nlfJaugdLr1+vl7+0RafJUT94aj6Yjz176XVcBIkFyuOR5nOk5
         EGqg/690uiNAiCmSXiR31vUkniWp3eY20ywLFe8iZfMa+S7mJDYm+UDn0MQluVugni/L
         yoaA==
X-Gm-Message-State: AOAM530fixbCUopsvdLHUTeH9NWF8jg7/g/eFIKuxUQnE1Q28pX2gxc1
        eGCR4kb0eWHEoJwiosktFJc=
X-Google-Smtp-Source: ABdhPJxu+PuOaxlAzsMyFahwSkNqujCfgEOO1ijyOjTluvDHDgzsVgJiHkP1QT0qyMI/+w6yz8HQBg==
X-Received: by 2002:a50:be86:: with SMTP id b6mr34762477edk.138.1632240950198;
        Tue, 21 Sep 2021 09:15:50 -0700 (PDT)
Received: from pinky.lan ([2a04:241e:502:1df0:b065:9bdf:4016:277])
        by smtp.gmail.com with ESMTPSA id kx17sm7674075ejc.51.2021.09.21.09.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:15:49 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 19/19] selftests: tcp_authopt: Add tests for rollover
Date:   Tue, 21 Sep 2021 19:15:02 +0300
Message-Id: <613b69cdbc7b22907af1e1359546b87822aa05d9.1632240523.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1632240523.git.cdleonard@gmail.com>
References: <cover.1632240523.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC5925 requires that the use can examine or control the keys being
used. This is implemented in linux via fields on the TCP_AUTHOPT
sockopt.

Add socket-level tests for the adjusting keyids on live connections and
checking the they are reflected on the peer.

Also check smooth transitions via rnextkeyid.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 .../tcp_authopt_test/linux_tcp_authopt.py     |  16 +-
 .../tcp_authopt_test/test_rollover.py         | 180 ++++++++++++++++++
 2 files changed, 193 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py

diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
index 339298998ff9..1ba4358654be 100644
--- a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/linux_tcp_authopt.py
@@ -23,10 +23,12 @@ TCP_AUTHOPT_KEY = 39
 
 TCP_AUTHOPT_MAXKEYLEN = 80
 
 
 class TCP_AUTHOPT_FLAG(IntFlag):
+    LOCK_KEYID = BIT(0)
+    LOCK_RNEXTKEYID = BIT(1)
     REJECT_UNEXPECTED = BIT(2)
 
 
 class TCP_AUTHOPT_KEY_FLAG(IntFlag):
     DEL = BIT(0)
@@ -42,24 +44,32 @@ class TCP_AUTHOPT_ALG(IntEnum):
 @dataclass
 class tcp_authopt:
     """Like linux struct tcp_authopt"""
 
     flags: int = 0
-    sizeof = 4
+    send_keyid: int = 0
+    send_rnextkeyid: int = 0
+    recv_keyid: int = 0
+    recv_rnextkeyid: int = 0
+    sizeof = 8
 
     def pack(self) -> bytes:
         return struct.pack(
-            "I",
+            "IBBBB",
             self.flags,
+            self.send_keyid,
+            self.send_rnextkeyid,
+            self.recv_keyid,
+            self.recv_rnextkeyid,
         )
 
     def __bytes__(self):
         return self.pack()
 
     @classmethod
     def unpack(cls, b: bytes):
-        tup = struct.unpack("I", b)
+        tup = struct.unpack("IBBBB", b)
         return cls(*tup)
 
 
 def set_tcp_authopt(sock, opt: tcp_authopt):
     return sock.setsockopt(socket.SOL_TCP, TCP_AUTHOPT, bytes(opt))
diff --git a/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py
new file mode 100644
index 000000000000..a348a7acfe0f
--- /dev/null
+++ b/tools/testing/selftests/tcp_authopt/tcp_authopt_test/test_rollover.py
@@ -0,0 +1,180 @@
+# SPDX-License-Identifier: GPL-2.0
+import typing
+import socket
+from .server import SimpleServerThread
+from .linux_tcp_authopt import (
+    TCP_AUTHOPT_FLAG,
+    set_tcp_authopt_key,
+    tcp_authopt,
+    tcp_authopt_key,
+    set_tcp_authopt,
+    get_tcp_authopt,
+)
+from .utils import DEFAULT_TCP_SERVER_PORT, create_listen_socket, check_socket_echo
+from contextlib import ExitStack, contextmanager
+from .conftest import skipif_missing_tcp_authopt
+
+pytestmark = skipif_missing_tcp_authopt
+
+
+@contextmanager
+def make_tcp_authopt_socket_pair(
+    server_addr="127.0.0.1",
+    server_authopt: tcp_authopt = None,
+    server_key_list: typing.Iterable[tcp_authopt_key] = [],
+    client_authopt: tcp_authopt = None,
+    client_key_list: typing.Iterable[tcp_authopt_key] = [],
+) -> typing.Tuple[socket.socket, socket.socket]:
+    """Make a pair for connected sockets for key switching tests
+
+    Server runs in a background thread implementing echo protocol"""
+    with ExitStack() as exit_stack:
+        listen_socket = exit_stack.enter_context(
+            create_listen_socket(bind_addr=server_addr)
+        )
+        server_thread = exit_stack.enter_context(
+            SimpleServerThread(listen_socket, mode="echo")
+        )
+        client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
+        client_socket.settimeout(1.0)
+
+        if server_authopt:
+            set_tcp_authopt(listen_socket, server_authopt)
+        for k in server_key_list:
+            set_tcp_authopt_key(listen_socket, k)
+        if client_authopt:
+            set_tcp_authopt(client_socket, client_authopt)
+        for k in client_key_list:
+            set_tcp_authopt_key(client_socket, k)
+
+        client_socket.connect((server_addr, DEFAULT_TCP_SERVER_PORT))
+        check_socket_echo(client_socket)
+        server_socket = server_thread.server_socket[0]
+
+        yield client_socket, server_socket
+
+
+def test_get_keyids(exit_stack: ExitStack):
+    """Check reading key ids"""
+    sk1 = tcp_authopt_key(send_id=11, recv_id=12, key="111")
+    sk2 = tcp_authopt_key(send_id=21, recv_id=22, key="222")
+    ck1 = tcp_authopt_key(send_id=12, recv_id=11, key="111")
+    client_socket, server_socket = exit_stack.enter_context(
+        make_tcp_authopt_socket_pair(
+            server_key_list=[sk1, sk2],
+            client_key_list=[ck1],
+        )
+    )
+
+    check_socket_echo(client_socket)
+    client_tcp_authopt = get_tcp_authopt(client_socket)
+    server_tcp_authopt = get_tcp_authopt(server_socket)
+    assert server_tcp_authopt.send_keyid == 11
+    assert server_tcp_authopt.send_rnextkeyid == 12
+    assert server_tcp_authopt.recv_keyid == 12
+    assert server_tcp_authopt.recv_rnextkeyid == 11
+    assert client_tcp_authopt.send_keyid == 12
+    assert client_tcp_authopt.send_rnextkeyid == 11
+    assert client_tcp_authopt.recv_keyid == 11
+    assert client_tcp_authopt.recv_rnextkeyid == 12
+
+
+def test_rollover_send_keyid(exit_stack: ExitStack):
+    """Check reading key ids"""
+    sk1 = tcp_authopt_key(send_id=11, recv_id=12, key="111")
+    sk2 = tcp_authopt_key(send_id=21, recv_id=22, key="222")
+    ck1 = tcp_authopt_key(send_id=12, recv_id=11, key="111")
+    ck2 = tcp_authopt_key(send_id=22, recv_id=21, key="222")
+    client_socket, server_socket = exit_stack.enter_context(
+        make_tcp_authopt_socket_pair(
+            server_key_list=[sk1, sk2],
+            client_key_list=[ck1, ck2],
+            client_authopt=tcp_authopt(
+                send_keyid=12, flags=TCP_AUTHOPT_FLAG.LOCK_KEYID
+            ),
+        )
+    )
+
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(client_socket).recv_keyid == 11
+    assert get_tcp_authopt(server_socket).recv_keyid == 12
+
+    # Explicit request for key2
+    set_tcp_authopt(
+        client_socket, tcp_authopt(send_keyid=22, flags=TCP_AUTHOPT_FLAG.LOCK_KEYID)
+    )
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(client_socket).recv_keyid == 21
+    assert get_tcp_authopt(server_socket).recv_keyid == 22
+
+
+def test_rollover_rnextkeyid(exit_stack: ExitStack):
+    """Check reading key ids"""
+    sk1 = tcp_authopt_key(send_id=11, recv_id=12, key="111")
+    sk2 = tcp_authopt_key(send_id=21, recv_id=22, key="222")
+    ck1 = tcp_authopt_key(send_id=12, recv_id=11, key="111")
+    ck2 = tcp_authopt_key(send_id=22, recv_id=21, key="222")
+    client_socket, server_socket = exit_stack.enter_context(
+        make_tcp_authopt_socket_pair(
+            server_key_list=[sk1],
+            client_key_list=[ck1, ck2],
+            client_authopt=tcp_authopt(
+                send_keyid=12, flags=TCP_AUTHOPT_FLAG.LOCK_KEYID
+            ),
+        )
+    )
+
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(server_socket).recv_rnextkeyid == 11
+
+    # request rnextkeyd=22 but server does not have it
+    set_tcp_authopt(
+        client_socket,
+        tcp_authopt(send_rnextkeyid=21, flags=TCP_AUTHOPT_FLAG.LOCK_RNEXTKEYID),
+    )
+    check_socket_echo(client_socket)
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(server_socket).recv_rnextkeyid == 21
+    assert get_tcp_authopt(server_socket).send_keyid == 11
+
+    # after adding k2 on server the key is switched
+    set_tcp_authopt_key(server_socket, sk2)
+    check_socket_echo(client_socket)
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(server_socket).send_keyid == 21
+
+
+def test_rollover_delkey(exit_stack: ExitStack):
+    sk1 = tcp_authopt_key(send_id=11, recv_id=12, key="111")
+    sk2 = tcp_authopt_key(send_id=21, recv_id=22, key="222")
+    ck1 = tcp_authopt_key(send_id=12, recv_id=11, key="111")
+    ck2 = tcp_authopt_key(send_id=22, recv_id=21, key="222")
+    client_socket, server_socket = exit_stack.enter_context(
+        make_tcp_authopt_socket_pair(
+            server_key_list=[sk1, sk2],
+            client_key_list=[ck1, ck2],
+            client_authopt=tcp_authopt(
+                send_keyid=12, flags=TCP_AUTHOPT_FLAG.LOCK_KEYID
+            ),
+        )
+    )
+
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(server_socket).recv_keyid == 12
+
+    # invalid send_keyid is just ignored
+    set_tcp_authopt(client_socket, tcp_authopt(send_keyid=7))
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(client_socket).send_keyid == 12
+    assert get_tcp_authopt(server_socket).recv_keyid == 12
+    assert get_tcp_authopt(client_socket).recv_keyid == 11
+
+    # If a key is removed it is replaced by anything that matches
+    ck1.delete_flag = True
+    set_tcp_authopt_key(client_socket, ck1)
+    check_socket_echo(client_socket)
+    check_socket_echo(client_socket)
+    assert get_tcp_authopt(client_socket).send_keyid == 22
+    assert get_tcp_authopt(server_socket).send_keyid == 21
+    assert get_tcp_authopt(server_socket).recv_keyid == 22
+    assert get_tcp_authopt(client_socket).recv_keyid == 21
-- 
2.25.1

