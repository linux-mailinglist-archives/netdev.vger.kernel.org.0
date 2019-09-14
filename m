Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1A4B2BC6
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 17:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfINPOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 11:14:03 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:43817 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfINPOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 11:14:03 -0400
Received: by mail-pl1-f175.google.com with SMTP id 4so14582879pld.10
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 08:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wXuGEYaZxkgVu4Q73ooL359B8gvbldJk9cPqByq6HF8=;
        b=KvkiuqBSSL6yxLJhRVwX4P4pshNorh6lsmFmZklgaoc6MHUXQatcIO9aj64rt0+7H8
         9nhYEhCpun1e+4f+RESxl0OQv0BoWWm4/oeWDUDV9ce+Nvubg4rg6+kLYBWTg6BXVXs/
         z9MyTTZGBHmOocXZVL0vpC6jsKkzYa3YE4NfHH8K/TDlXrjBKu2x7FhYvAqSpBNUt4PU
         7fBDgUg5Fgv1tMzAvC/veiP+EdKPvK+7ogArW1uN0ent7IMVsnD1hUhP3qf4kRz9fmmK
         sgBnnLO3n1INaOFwDL9AXHBuD+zDCReLk0T/3yHxdEqtsx/r2YGbuDk97KuqCb4aF2mK
         BvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wXuGEYaZxkgVu4Q73ooL359B8gvbldJk9cPqByq6HF8=;
        b=izsJWQVpxNX99lt+HSrmcdTJu8tgVAN+ndUqdh3A2868rZySdOA6zybw+zYotBapRp
         PPHhHWs4lxGCKrDz3K7hkqJj53FyqV2f3xcOUFm/OlNlWmN6O1PeEGmpB1BcRiH+7/qP
         RE9rtTD2uhMGeMBJaXuAm+QgkkcP1GG2YlKKaRtmjh+kFDRMewfIpZa4fsA2j/zXtKm+
         dR0bSFK23Zb6Ql6kAmq2L8Yv+i98BMpk8WzdJNj1GktsnObOW13AFqHZUHDcLPzQTmR7
         sSKKuFHS3SO72Pj6zNhbYtdq+zqWW4XycznMKnMIvHuBW7dEDXxWE61VGLCZ3hrFL2Hn
         YNPQ==
X-Gm-Message-State: APjAAAVMsLDW5752eEvOols6W4FBOQzXKmobd6yChCq3T9lrPQyHjsrv
        p2Ojkcvta4tCfecCX5sLLxVR0+Y=
X-Google-Smtp-Source: APXvYqw/HSvtyr1d9DSXad/Kt9gDjs4JHbI/Dyt/+33CnsRUps1ynKMypH765EBRRwrhlRkgBkH7vQ==
X-Received: by 2002:a17:902:9d90:: with SMTP id c16mr43782494plq.12.1568474042653;
        Sat, 14 Sep 2019 08:14:02 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id u69sm28408689pgu.77.2019.09.14.08.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 08:14:02 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [v3 2/3] samples: pktgen: add helper functions for IP(v4/v6) CIDR parsing
Date:   Sun, 15 Sep 2019 00:13:52 +0900
Message-Id: <20190914151353.18054-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190914151353.18054-1-danieltimlee@gmail.com>
References: <20190914151353.18054-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds CIDR parsing and IP validate helper function to parse
single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)

Helpers will be used in prior to set target address in samples/pktgen.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
Changes since v3:
 * Set errexit option to stop script execution on error

 samples/pktgen/functions.sh | 124 ++++++++++++++++++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/samples/pktgen/functions.sh b/samples/pktgen/functions.sh
index 4af4046d71be..87ae61701904 100644
--- a/samples/pktgen/functions.sh
+++ b/samples/pktgen/functions.sh
@@ -5,6 +5,8 @@
 # Author: Jesper Dangaaard Brouer
 # License: GPL
 
+set -o errexit
+
 ## -- General shell logging cmds --
 function err() {
     local exitcode=$1
@@ -163,6 +165,128 @@ function get_node_cpus()
 	echo $node_cpu_list
 }
 
+# Extend shrunken IPv6 address.
+# fe80::42:bcff:fe84:e10a => fe80:0:0:0:42:bcff:fe84:e10a
+function extend_addr6()
+{
+    local addr=$1
+    local sep=: sep2=::
+    local sep_cnt=$(tr -cd $sep <<< $1 | wc -c)
+    local shrink
+
+    # separator count : should be between 2, 7.
+    if [[ $sep_cnt -lt 2 || $sep_cnt -gt 7 ]]; then
+        err 5 "Invalid IP6 address sep: $1"
+    fi
+
+    # if shrink '::' occurs multiple, it's malformed.
+    shrink=( $(egrep -o "$sep{2,}" <<< $addr) )
+    if [[ ${#shrink[@]} -ne 0 ]]; then
+        if [[ ${#shrink[@]} -gt 1 || ( ${shrink[0]} != $sep2 ) ]]; then
+            err 5 "Invalid IP$IP6 address shr: $1"
+        fi
+    fi
+
+    # add 0 at begin & end, and extend addr by adding :0
+    [[ ${addr:0:1} == $sep ]] && addr=0${addr}
+    [[ ${addr: -1} == $sep ]] && addr=${addr}0
+    echo "${addr/$sep2/$(printf ':0%.s' $(seq $[8-sep_cnt])):}"
+}
+
+
+# Given a single IP(v4/v6) address, whether it is valid.
+function validate_addr()
+{
+    # check function is called with (funcname)6
+    [[ ${FUNCNAME[1]: -1} == 6 ]] && local IP6=6
+    local len=$[ IP6 ? 8 : 4 ]
+    local max=$[ 2**(len*2)-1 ]
+    local addr sep
+
+    # set separator for each IP(v4/v6)
+    [[ $IP6 ]] && sep=: || sep=.
+    IFS=$sep read -a addr <<< $1
+
+    # array length
+    if [[ ${#addr[@]} != $len ]]; then
+        err 5 "Invalid IP$IP6 address: $1"
+    fi
+
+    # check each digit between 0, $max
+    for digit in "${addr[@]}"; do
+        [[ $IP6 ]] && digit=$[ 16#$digit ]
+        if [[ $digit -lt 0 || $digit -gt $max ]]; then
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
+    local bitlen=$[ IP6 ? 128 : 32 ]
+    local octet=$[ IP6 ? 16 : 8 ]
+
+    local addr=$1
+    local net prefix
+    local min_ip max_ip
+
+    IFS='/' read net prefix <<< $addr
+    [[ $IP6 ]] && net=$(extend_addr6 $net)
+    validate_addr$IP6 $net
+
+    if [[ $prefix -gt $bitlen ]]; then
+        err 5 "Invalid prefix: $prefix"
+    elif [[ -z $prefix ]]; then
+        min_ip=$net
+        max_ip=$net
+    else
+        # defining array for converting Decimal 2 Binary
+        # 00000000 00000001 00000010 00000011 00000100 ...
+        local d2b='{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}'
+        [[ $IP6 ]] && d2b+=$d2b
+        eval local D2B=($d2b)
+
+        local remain=$[ bitlen-prefix ]
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
-- 
2.20.1

