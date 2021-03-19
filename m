Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2F23417D3
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 09:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhCSI5i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Mar 2021 04:57:38 -0400
Received: from mslow2.mail.gandi.net ([217.70.178.242]:56871 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhCSI5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 04:57:17 -0400
Received: from relay13.mail.gandi.net (unknown [217.70.178.233])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id CD2A2424256
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:35:49 +0000 (UTC)
Received: from localhost (unknown [151.79.131.81])
        (Authenticated sender: pbl@bestov.io)
        by relay13.mail.gandi.net (Postfix) with ESMTPSA id AA55B80015
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:35:28 +0000 (UTC)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Subject: IP_FREEBIND not working with SOCK_RAW socket
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
To:     <netdev@vger.kernel.org>
Date:   Fri, 19 Mar 2021 08:58:01 +0100
Message-Id: <CA1623NCR32W.28H2TORVKG2SL@enhorning>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,

I noticed that the IP_FREEBIND socket option doesn't work with the
SOCK_RAW socket type, nor does the net.ipv4.ip_nonlocal_bind kernel
parameter. When attempting to bind a nonlocal address to such a socket,
EADDRNOTAVAIL is returned.

I briefly adventured into the Kernel Source in search of insights, but
soon got lost in the Dark Forest of The Structs and had to get rescued.

I've attach below a small program to reproduce the issue. It gives no
output whatsoever, so you might want to run it through strace.

You should attempt to run it with an actual local address to observe it
works:
# strace ./a.out 127.0.0.1

And then run it with a nonlocal address to observe it doesn't work both
without (ok) or with (not ok?) the IP_FREEBIND socket option:
# strace ./a.out 8.8.8.8
# strace ./a.out 8.8.8.8 freebind

Any insights?

Riccardo P. Bestetti
--

#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>

int main (int argc, char** argv) {
  char src[16];
  unsigned int freebind = 0;

  if (argc < 2) {
    fprintf(stderr, "Usage: out.a ADDR [ freebind ]\n");
    return 1;
  }

  strncpy(src, argv[1], 16);
  src[15] = 0;

  if (argc >= 3 && strcmp(argv[2], "freebind") == 0)
    freebind = 1;

  struct sockaddr_in bind_addr;
  socklen_t laddrlen = sizeof(bind_addr);
  memset(&bind_addr, 0, laddrlen);
  bind_addr.sin_family = AF_INET;
  bind_addr.sin_port = htons(IPPROTO_GRE);
  inet_pton(AF_INET, src, &bind_addr.sin_addr);

  int fd = socket(AF_INET, SOCK_RAW, IPPROTO_GRE);
  setsockopt(fd, IPPROTO_IP, IP_FREEBIND, &freebind, sizeof(freebind));
  bind(fd, (struct sockaddr *)&bind_addr, laddrlen);

  return 0;
}


