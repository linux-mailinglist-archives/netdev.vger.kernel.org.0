Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF61CB30E
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 03:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbfJDBdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 21:33:16 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:40844 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbfJDBdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 21:33:16 -0400
Received: by mail-pl1-f175.google.com with SMTP id d22so2350653pll.7
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 18:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O2ZyA+tQW34jsrCsqhPPazh82aI4Blm0LcxATXbiew0=;
        b=XPtn9/0e13VSD5+T/Da11Fsm1UCxFQRyfHRabf2FqceNnGex73Mw0R1wpYXP873Tt7
         vHBblg1aNMTWgLqj7ZINYckvNs+mycAYQaucRstnQzq893hcZJnki/sM9+Hv69eoppLU
         hf5BcEMAu2oxLD0sHoHU4+ROqMIzAwUo0N2IyLjIkCRZUfLIqpK/OlkBZBFSY+LTnDB0
         UehMt/q/kYm1AM2mCMhpEmH0UBbT0xYW8Vfs4sohjTOG5AOK4aNg2+tWT54w+aGEWDel
         AzHevUcNXFNEsE7RGunR9v42sRexKDDJ46Lx8l2IzTHcsk8Z6nukSYfReCaiPHTgr8S2
         CDaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O2ZyA+tQW34jsrCsqhPPazh82aI4Blm0LcxATXbiew0=;
        b=Z5NtAf8DgGKuqNgJXfOo/evzKbysQt8fa8Q4Y9Um7+bDPd/LKZZ8xXll7hYdOsNODs
         adNWL1NtuYvQnweiSgQ+ONdMV67jWRJIVghJZTV9qQoEFHAkAZadd9bTPb57VQ1pa9hp
         16mry4t1tYSYHxTSPFE7uIV9RChmCsNXD16grZ6s6kfGmw0yGXuuDKDl1Fweg2GGhyP7
         nxLDYt/W1D8deMnVQwS02WdUKct8UZO1nOoBqUEgM1SxCbh7d6unMEGjTP79++/sHtLc
         jyMQVqdDe2NdnamRk0BBHqU87ElVYnDUXGxkVZzRmpnwCQ0gQb9Q0Ja54kVXYzCVTzAJ
         MgFg==
X-Gm-Message-State: APjAAAX2XGxGD/FovnZEobixvSSjdIoE1+zKt5xJupQye3FFtGSkeHzz
        IV9B3ZFGbg3JMlzDnPBXGEa3VHVqMrcH
X-Google-Smtp-Source: APXvYqwfCpBVN/y7Ttdglj8kpRN6KIcqizKSweCZtmE+AddbwXN570WcegNz1LlKQNdKkLXoFRgluw==
X-Received: by 2002:a17:902:b482:: with SMTP id y2mr12522144plr.334.1570152794585;
        Thu, 03 Oct 2019 18:33:14 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id 127sm4291495pfw.6.2019.10.03.18.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 18:33:13 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [v4 3/4] samples: pktgen: add helper functions for IP(v4/v6) CIDR parsing
Date:   Fri,  4 Oct 2019 10:33:00 +0900
Message-Id: <20191004013301.8686-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191004013301.8686-1-danieltimlee@gmail.com>
References: <20191004013301.8686-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds CIDR parsing and IP validate helper function to parse
single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)

Validating the address should be preceded prior to the parsing.
Helpers will be used in prior to set target address in samples/pktgen.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
Changes since v3:
 * Set errexit option to stop script execution on error

Changes since v4:
 * Set errexit option moved to previous commit
 * previously, the reason 'parse_addr' won't exit on error was using 
   here-string which runs on subshell.
 * to avoid this, 'validate_addr' is removed from the 'parse_addr' flow.
 * to remove duplicated comparison, added 'in_between' helper func

samples/pktgen/functions.sh | 137 +++++++++++++++++++++++++++++++++++-
 1 file changed, 134 insertions(+), 3 deletions(-)

diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index e1865660b033..a450a0844313 100644
--- a/samples/pktgen/functions.sh
+++ b/samples/pktgen/functions.sh
@@ -169,6 +169,137 @@ function get_node_cpus()
 	echo $node_cpu_list
 }
 
+# Check $1 is in between $2, $3 ($2 <= $1 <= $3)
+function in_between() { [[ ($1 -ge $2) && ($1 -le $3) ]] ; }
+
+# Extend shrunken IPv6 address.
+# fe80::42:bcff:fe84:e10a => fe80:0:0:0:42:bcff:fe84:e10a
+function extend_addr6()
+{
+    local addr=$1
+    local sep=: sep2=::
+    local sep_cnt=$(tr -cd $sep <<< $1 | wc -c)
+    local shrink
+
+    # separator count should be (2 <= $sep_cnt <= 7)
+    if ! (in_between $sep_cnt 2 7); then
+        err 5 "Invalid IP6 address: $1"
+    fi
+
+    # if shrink '::' occurs multiple, it's malformed.
+    shrink=( $(egrep -o "$sep{2,}" <<< $addr) )
+    if [[ ${#shrink[@]} -ne 0 ]]; then
+        if [[ ${#shrink[@]} -gt 1 || ( ${shrink[0]} != $sep2 ) ]]; then
+            err 5 "Invalid IP6 address: $1"
+        fi
+    fi
+
+    # add 0 at begin & end, and extend addr by adding :0
+    [[ ${addr:0:1} == $sep ]] && addr=0${addr}
+    [[ ${addr: -1} == $sep ]] && addr=${addr}0
+    echo "${addr/$sep2/$(printf ':0%.s' $(seq $[8-sep_cnt])):}"
+}
+
+# Given a single IP(v4/v6) address, whether it is valid.
+function validate_addr()
+{
+    # check function is called with (funcname)6
+    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
+    local bitlen=$[ IP6 ? 128 : 32 ]
+    local len=$[ IP6 ? 8 : 4 ]
+    local max=$[ 2**(len*2)-1 ]
+    local net prefix
+    local addr sep
+
+    IFS='/' read net prefix <<< $1
+    [[ $IP6 ]] && net=$(extend_addr6 $net)
+
+    # if prefix exists, check (0 <= $prefix <= $bitlen)
+    if [[ -n $prefix ]]; then
+        if ! (in_between $prefix 0 $bitlen); then
+            err 5 "Invalid prefix: /$prefix"
+        fi
+    fi
+
+    # set separator for each IP(v4/v6)
+    [[ $IP6 ]] && sep=: || sep=.
+    IFS=$sep read -a addr <<< $net
+
+    # array length
+    if [[ ${#addr[@]} != $len ]]; then
+        err 5 "Invalid IP$IP6 address: $1"
+    fi
+
+    # check each digit (0 <= $digit <= $max)
+    for digit in "${addr[@]}"; do
+        [[ $IP6 ]] && digit=$[ 16#$digit ]
+        if ! (in_between $digit 0 $max); then
+            err 5 "Invalid IP$IP6 address: $1"
+        fi
+    done
+
+    return 0
+}
+
+function validate_addr6() { validate_addr $@ ; }
+
+# Given a single IP(v4/v6) or CIDR, return minimum and maximum IP addr.
+function parse_addr()
+{
+    # check function is called with (funcname)6
+    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
+    local net prefix
+    local min_ip max_ip
+
+    IFS='/' read net prefix <<< $1
+    [[ $IP6 ]] && net=$(extend_addr6 $net)
+
+    if [[ -z $prefix ]]; then
+        min_ip=$net
+        max_ip=$net
+    else
+        # defining array for converting Decimal 2 Binary
+        # 00000000 00000001 00000010 00000011 00000100 ...
+        local d2b='{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}'
+        [[ $IP6 ]] && d2b+=$d2b
+        eval local D2B=($d2b)
+
+        local bitlen=$[ IP6 ? 128 : 32 ]
+        local remain=$[ bitlen-prefix ]
+        local octet=$[ IP6 ? 16 : 8 ]
+        local min_mask max_mask
+        local min max
+        local ip_bit
+        local ip sep
+
+        # set separator for each IP(v4/v6)
+        [[ $IP6 ]] && sep=: || sep=.
+        IFS=$sep read -ra ip <<< $net
+
+        min_mask="$(printf '1%.s' $(seq $prefix))$(printf '0%.s' $(seq $remain))"
+        max_mask="$(printf '0%.s' $(seq $prefix))$(printf '1%.s' $(seq $remain))"
+
+        # calculate min/max ip with &,| operator
+        for i in "${!ip[@]}"; do
+            digit=$[ IP6 ? 16#${ip[$i]} : ${ip[$i]} ]
+            ip_bit=${D2B[$digit]}
+
+            idx=$[ octet*i ]
+            min[$i]=$[ 2#$ip_bit & 2#${min_mask:$idx:$octet} ]
+            max[$i]=$[ 2#$ip_bit | 2#${max_mask:$idx:$octet} ]
+            [[ $IP6 ]] && { min[$i]=$(printf '%X' ${min[$i]});
+                            max[$i]=$(printf '%X' ${max[$i]}); }
+        done
+
+        min_ip=$(IFS=$sep; echo "${min[*]}")
+        max_ip=$(IFS=$sep; echo "${max[*]}")
+    fi
+
+    echo $min_ip $max_ip
+}
+
+function parse_addr6() { parse_addr $@ ; }
+
 # Given a single or range of port(s), return minimum and maximum port number.
 function parse_ports()
 {
@@ -191,9 +322,9 @@ function validate_ports()
     local min_port=$1
     local max_port=$2
 
-    # 0 < port < 65536
-    if [[ $min_port -gt 0 && $min_port -lt 65536 ]]; then
-	if [[ $max_port -gt 0 && $max_port -lt 65536 ]]; then
+    # 1 <= port <= 65535
+    if (in_between $min_port 1 65535); then
+	if (in_between $max_port 1 65535); then
 	    if [[ $min_port -le $max_port ]]; then
 		return 0
 	    fi
-- 
2.20.1

