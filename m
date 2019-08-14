Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D248DAEA
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbfHNRVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730393AbfHNRJv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 13:09:51 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD4E72084D;
        Wed, 14 Aug 2019 17:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802590;
        bh=1pS0y7l4ZwDyoC2vK2GRS+Mr7Teh4kKSBAc4Hhow+00=;
        h=From:To:Cc:Subject:Date:From;
        b=DOasNQPt51sCvvvvSuuGXcX5it6eWu9hWQ8UFYibKY3wOoxklDOBgcm+Noq5TrRR+
         jAxNeqvpucg+UGyZCMBDUmOac2c1YnMzdz6/xKInhrXixkD+YKVhV2bsBv3Z+JxBvf
         /+wx6rhWvcZLTfYdAh6Z2EXuW/N6OeSB4ppBGkNc=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dan.carpenter@oracle.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next] selftests: Fix get_ifidx and callers in nettest.c
Date:   Wed, 14 Aug 2019 10:11:51 -0700
Message-Id: <20190814171151.27739-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Dan reported:

    The patch acda655fefae: "selftests: Add nettest" from Aug 1, 2019,
    leads to the following static checker warning:

            ./tools/testing/selftests/net/nettest.c:1690 main()
            warn: unsigned 'tmp' is never less than zero.

    ./tools/testing/selftests/net/nettest.c
      1680                  case '1':
      1681                          args.has_expected_raddr = 1;
      1682                          if (convert_addr(&args, optarg,
      1683                                           ADDR_TYPE_EXPECTED_REMOTE))
      1684                                  return 1;
      1685
      1686                          break;
      1687                  case '2':
      1688                          if (str_to_uint(optarg, 0, 0x7ffffff, &tmp) != 0) {
      1689                                  tmp = get_ifidx(optarg);
      1690                                  if (tmp < 0) {

    "tmp" is unsigned so it can't be negative.  Also all the callers assume
    that get_ifidx() returns negatives on error but it looks like it really
    returns zero on error so it's a bit unclear to me.

Update get_ifidx to return -1 on errors and cleanup callers of it.

Fixes: acda655fefae ("selftests: Add nettest")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 83515e5ea4dc..c08f4db8330d 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -266,7 +266,7 @@ static int get_ifidx(const char *ifname)
 	int sd, rc;
 
 	if (!ifname || *ifname == '\0')
-		return 0;
+		return -1;
 
 	memset(&ifdata, 0, sizeof(ifdata));
 
@@ -275,14 +275,14 @@ static int get_ifidx(const char *ifname)
 	sd = socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);
 	if (sd < 0) {
 		log_err_errno("socket failed");
-		return 0;
+		return -1;
 	}
 
 	rc = ioctl(sd, SIOCGIFINDEX, (char *)&ifdata);
 	close(sd);
 	if (rc != 0) {
 		log_err_errno("ioctl(SIOCGIFINDEX) failed");
-		return 0;
+		return -1;
 	}
 
 	return ifdata.ifr_ifindex;
@@ -419,20 +419,20 @@ static int set_multicast_if(int sd, int ifindex)
 	return rc;
 }
 
-static int set_membership(int sd, uint32_t grp, uint32_t addr, const char *dev)
+static int set_membership(int sd, uint32_t grp, uint32_t addr, int ifindex)
 {
 	uint32_t if_addr = addr;
 	struct ip_mreqn mreq;
 	int rc;
 
-	if (addr == htonl(INADDR_ANY) && !dev) {
+	if (addr == htonl(INADDR_ANY) && !ifindex) {
 		log_error("Either local address or device needs to be given for multicast membership\n");
 		return -1;
 	}
 
 	mreq.imr_multiaddr.s_addr = grp;
 	mreq.imr_address.s_addr = if_addr;
-	mreq.imr_ifindex = dev ? get_ifidx(dev) : 0;
+	mreq.imr_ifindex = ifindex;
 
 	rc = setsockopt(sd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreq, sizeof(mreq));
 	if (rc < 0) {
@@ -1048,7 +1048,7 @@ static int msock_init(struct sock_args *args, int server)
 
 	if (server &&
 	    set_membership(sd, args->grp.s_addr,
-			   args->local_addr.in.s_addr, args->dev))
+			   args->local_addr.in.s_addr, args->ifindex))
 		goto out_err;
 
 	return sd;
@@ -1685,15 +1685,16 @@ int main(int argc, char *argv[])
 
 			break;
 		case '2':
-			if (str_to_uint(optarg, 0, 0x7ffffff, &tmp) != 0) {
-				tmp = get_ifidx(optarg);
-				if (tmp < 0) {
+			if (str_to_uint(optarg, 0, INT_MAX, &tmp) == 0) {
+				args.expected_ifindex = (int)tmp;
+			} else {
+				args.expected_ifindex = get_ifidx(optarg);
+				if (args.expected_ifindex < 0) {
 					fprintf(stderr,
-						"Invalid device index\n");
+						"Invalid expected device\n");
 					return 1;
 				}
 			}
-			args.expected_ifindex = (int)tmp;
 			break;
 		case 'q':
 			quiet = 1;
-- 
2.11.0

