Return-Path: <netdev+bounces-9725-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A521472A579
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:43:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EE6F281A0C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F7BF23430;
	Fri,  9 Jun 2023 21:43:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC17408E0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4A1C433EF;
	Fri,  9 Jun 2023 21:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347034;
	bh=Ydyrv+SagVBW2AlJj4EZ84PWRICnVuIK6cvcr1VrQbo=;
	h=From:To:Cc:Subject:Date:From;
	b=PvEeTVZ49bXiPViTcr4lkEQohCPgwaJjmNUEkJvJyyO8hw/togJNotFVY8BGFIMfW
	 iFOSgoMSHqD7uImAd400Kbo+tcsZ9uS/otcxUMQC+BIrTdjjdWk8JdqVu64QqBh89x
	 pR0GN4tjMWGssgcra8DakqhXRIH4GlGJt0fZ6cuUzZWRhpWQVND5tUBiKwSoeRci8R
	 FT2eZsgE5dCj0PDBKsTsrSRrjtUcYQVKUW0+LHy58uSXUnS7P4TEAocywZ4InUsa+4
	 KOdf8VtdfRYMX6UexN72odhX6ToT/X1t66X3DnyMQawnBo+OwkOtMXpgVVzBLAl3TV
	 lpQRiKkakVm/Q==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	sdf@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/12] tools: ynl: generate code for the ethtool family
Date: Fri,  9 Jun 2023 14:43:34 -0700
Message-Id: <20230609214346.1605106-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

And finally ethtool support. Thanks to Stan's work the ethtool family
spec is quite complete, so there is a lot of operations to support.

I chickened out of stats-get support, they require at the very least
type-value support on a u64 scalar. Type-value is an arrangement where
a u16 attribute is encoded directly in attribute type. Code gen can
support this if the inside is a nest, we just throw in an extra
field into that nest to carry the attr type. But a little more coding
is needed to for a scalar, because first we need to turn the scalar
into a struct with one member, then we can add the attr type.

Other than that ethtool required event support (notification which
does not share contents with any GET), but the previous series
already added that to the codegen.

I haven't tested all the ops here, and a few I tried seem to work.

Jakub Kicinski (12):
  tools: ynl-gen: support excluding tricky ops
  tools: ynl-gen: record extra args for regen
  netlink: specs: support setting prefix-name per attribute
  netlink: specs: ethtool: add C render hints
  tools: ynl-gen: don't generate enum types if unnamed
  tools: ynl-gen: resolve enum vs struct name conflicts
  netlink: specs: ethtool: add empty enum stringset
  netlink: specs: ethtool: untangle UDP tunnels and cable test a bit
  netlink: specs: ethtool: untangle stats-get
  netlink: specs: ethtool: mark pads as pads
  tools: ynl: generate code for the ethtool family
  tools: ynl: add sample for ethtool

 Documentation/netlink/genetlink-c.yaml      |    4 +
 Documentation/netlink/genetlink-legacy.yaml |    4 +
 Documentation/netlink/specs/ethtool.yaml    |  120 +-
 tools/net/ynl/generated/Makefile            |    9 +-
 tools/net/ynl/generated/ethtool-user.c      | 6353 +++++++++++++++++++
 tools/net/ynl/generated/ethtool-user.h      | 5531 ++++++++++++++++
 tools/net/ynl/lib/nlspec.py                 |   12 +-
 tools/net/ynl/samples/.gitignore            |    1 +
 tools/net/ynl/samples/ethtool.c             |   65 +
 tools/net/ynl/ynl-gen-c.py                  |   59 +-
 tools/net/ynl/ynl-regen.sh                  |    4 +-
 11 files changed, 12116 insertions(+), 46 deletions(-)
 create mode 100644 tools/net/ynl/generated/ethtool-user.c
 create mode 100644 tools/net/ynl/generated/ethtool-user.h
 create mode 100644 tools/net/ynl/samples/ethtool.c

-- 
2.40.1


